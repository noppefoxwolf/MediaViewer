import UIKit
import AVKit
import os

fileprivate let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier! + ".logger",
    category: #file
)

public final class PlayerPreviewItemViewController: UIViewController {
    private let playerView = AVPlayerView()
    
    let player: AVPlayer
    
    public init(player: AVPlayer) {
        self.player = player
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public override func loadView() {
        view = playerView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        playerView.playerLayer.player = player
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
