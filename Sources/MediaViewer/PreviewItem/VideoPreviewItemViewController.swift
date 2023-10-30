import UIKit
import AVKit

public final class VideoPreviewItemViewController: UIViewController {
    private let playerView = AVPlayerView()
    
    public override func loadView() {
        view = playerView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/adv_dv_atmos/main.m3u8")
        playerView.playerLayer.player = AVPlayer(url: url!)
        playerView.playerLayer.player?.play()
    }
}

fileprivate final class AVPlayerView: UIView {
    override class var layerClass: AnyClass { AVPlayerLayer.self }
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
}
