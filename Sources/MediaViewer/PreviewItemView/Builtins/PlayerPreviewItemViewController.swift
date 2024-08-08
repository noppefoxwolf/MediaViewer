import UIKit
import AVKit
import VideoToolbox
import os

fileprivate let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier! + ".logger",
    category: #file
)

public final class PlayerPreviewItemViewController: AVPlayerViewController {
    private var playerOutput: AVPlayerItemVideoOutput
    
    public init(player: AVPlayer) {
        playerOutput = AVPlayerItemVideoOutput(pixelBufferAttributes:
                                                [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)])
        super.init(nibName: nil, bundle: nil)
        self.player = player
        allowsPictureInPicturePlayback = false
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        player?.currentItem?.add(playerOutput)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logger.debug("\(#function)")
        player?.play()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logger.debug("\(#function)")
        player?.pause()
    }
}

extension PlayerPreviewItemViewController: DismissTransitionViewProviding {
    public var viewForDismissTransition: UIView? {
        guard let player else { return nil }
        if let asset = player.currentItem?.asset {
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.requestedTimeToleranceAfter = CMTime.zero
            imageGenerator.requestedTimeToleranceBefore = CMTime.zero
            imageGenerator.appliesPreferredTrackTransform = true
            if let thumb: CGImage = try? imageGenerator.copyCGImage(at: player.currentTime(), actualTime: nil) {
                let image = UIImage(cgImage: thumb)
                let imageView = UIImageView(image: image)
                imageView.frame = AVMakeRect(aspectRatio: image.size, insideRect: view.bounds)
                return imageView
            }
            
        }
        return nil
    }
}
