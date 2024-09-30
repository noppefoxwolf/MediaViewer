import UIKit
import AVKit
import Combine
import os

fileprivate let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier! + ".logger",
    category: #file
)

@MainActor
public final class PlayerPreviewItemViewController: AVPlayerViewController {
    private var cancellables = Set<AnyCancellable>()
    
    public var willStartPlayingMovie: (() -> Void)?
    public var didStopPlayingMovie: (() -> Void)?
    
    public let identifier = UUID().uuidString
    
    public init(player: AVPlayer) {
        super.init(nibName: nil, bundle: nil)
        requiresLinearPlayback = false
        updatesNowPlayingInfoCenter = false
        self.player = player
        allowsPictureInPicturePlayback = false
        setupObservers()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupObservers() {
        guard let player = player else { return }
        
        player.publisher(for: \.timeControlStatus)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                switch status {
                case .paused:
                    self?.didStopPlayingMovie?()
                case .waitingToPlayAtSpecifiedRate:
                    self?.willStartPlayingMovie?()
                @unknown default:
                    break
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.didStopPlayingMovie?()
            }
            .store(in: &cancellables)
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logger.debug("\(#function)")
        player?.play()
        if let navigationController = navigationController as? NavigationController {
            navigationController.setBarHidden(false, animated: true)
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logger.debug("\(#function)")
        player?.pause()
    }
}

@MainActor
extension PlayerPreviewItemViewController: DismissTransitionViewProviding {
    public var viewForDismissTransition: UIView? {
        guard let player, let asset = player.currentItem?.asset else {
            return nil
        }
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.requestedTimeToleranceAfter = CMTime.zero
        imageGenerator.requestedTimeToleranceBefore = CMTime.zero
        imageGenerator.appliesPreferredTrackTransform = true
        guard let thumb: CGImage = try? imageGenerator.copyCGImage(at: player.currentTime(), actualTime: nil) else {
            return nil
        }
        let image = UIImage(cgImage: thumb)
        let imageView = UIImageView(image: image)
        imageView.frame = AVMakeRect(aspectRatio: image.size, insideRect: view.bounds)
        return imageView
    }
}
