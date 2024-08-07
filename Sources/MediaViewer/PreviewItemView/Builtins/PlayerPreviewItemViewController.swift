import UIKit
import AVKit
import VideoToolbox
import os

fileprivate let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier! + ".logger",
    category: #file
)

public final class PlayerPreviewItemViewController: UIViewController {
    private let playerView = AVPlayerView()
    private var playerOutput: AVPlayerItemVideoOutput
    let player: AVPlayer
    
    public init(player: AVPlayer) {
        self.player = player
        playerOutput = AVPlayerItemVideoOutput(pixelBufferAttributes:
                                                [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public override func loadView() {
        view = playerView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        playerView.playerLayer.player = player
        player.currentItem?.add(playerOutput)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logger.debug("\(#function)")
        player.play()
        navigationController?.topViewController?.toolbarItems = [
            UIBarButtonItem.seekbar(player)
        ]
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logger.debug("\(#function)")
        player.pause()
        navigationController?.topViewController?.toolbarItems = []
    }
}

fileprivate final class AVPlayerView: UIView {
    override class var layerClass: AnyClass { AVPlayerLayer.self }
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
}

extension PlayerPreviewItemViewController: DismissTransitionViewProviding {
    public var viewForDismissTransition: UIView? {
        if let asset = player.currentItem?.asset {
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.requestedTimeToleranceAfter = CMTime.zero
            imageGenerator.requestedTimeToleranceBefore = CMTime.zero
            imageGenerator.appliesPreferredTrackTransform = true
            if let thumb: CGImage = try? imageGenerator.copyCGImage(at: player.currentTime(), actualTime: nil) {
                let image = UIImage(cgImage: thumb)
                let imageView = UIImageView(image: image)
                imageView.frame = AVMakeRect(aspectRatio: image.size, insideRect: playerView.bounds)
                return imageView
            }
            
        }
        return nil
    }
}
