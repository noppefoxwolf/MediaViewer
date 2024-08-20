import UIKit
import AVKit
import VideoToolbox
import os

fileprivate let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier! + ".logger",
    category: #file
)

@MainActor
public final class PlayerPreviewItemViewController: AVPlayerViewController {
    
    public init(player: AVPlayer) {
        super.init(nibName: nil, bundle: nil)
        self.player = player
        allowsPictureInPicturePlayback = false
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
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
