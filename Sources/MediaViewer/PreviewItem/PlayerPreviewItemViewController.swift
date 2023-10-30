import UIKit
import AVKit

public final class PlayerPreviewItemViewController: UIViewController {
    private let playerView = AVPlayerView()
    
    let player = AVPlayer(url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/adv_dv_atmos/main.m3u8")!)
    
    public override func loadView() {
        view = playerView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        playerView.playerLayer.player = player
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.play()
        navigationController?.topViewController?.toolbarItems = [
            UIBarButtonItem.seekbar(player)
        ]
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
        navigationController?.topViewController?.toolbarItems = []
    }
}

fileprivate final class AVPlayerView: UIView {
    override class var layerClass: AnyClass { AVPlayerLayer.self }
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
}