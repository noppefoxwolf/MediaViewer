public import UIKit
public import AVKit
import os
import Combine

public final class PlayerPreviewItemViewController: UIViewController {
    let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: #file
    )

    private let playerView = AVPlayerView()
    private let contentUnavailableView = UIContentUnavailableView(configuration: .empty())
    
    let player: AVPlayer
    var cancellables: Set<AnyCancellable> = []
    
    public init(player: AVPlayer) {
        self.player = player
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public override func loadView() {
        view = playerView
        view.addSubview(contentUnavailableView)
        contentUnavailableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                contentUnavailableView.topAnchor.constraint(
                    equalTo: view.topAnchor
                ),
                contentUnavailableView.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor
                ),
                contentUnavailableView.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor
                ),
                contentUnavailableView.bottomAnchor.constraint(
                    equalTo: view.bottomAnchor
                ),
            ]
        )
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        playerView.playerLayer.player = player
        
        player.currentItem?
            .publisher(for: \.error)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                var configuration = UIContentUnavailableConfiguration.empty()
                if let error {
                    configuration.secondaryText = error.localizedDescription
                }
                self?.contentUnavailableView.configuration = configuration
            }
            .store(in: &cancellables)
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
