import UIKit
import AVKit

extension UIBarButtonItem {
    static func seekbar(_ player: AVPlayer) -> UIBarButtonItem {
        UIBarButtonItem(customView: Seekbar(player))
    }
}

import Combine

fileprivate final class Seekbar: UIControl {
    let player: AVPlayer
    let playbackButton = UIButton(configuration: .playback())
    private let timeLabel = TimeLabel()
    let slider = UISlider()
    var timeObserver: Any = ()
    var durationObserver: AnyCancellable? = nil
    var playbackObserver: AnyCancellable? = nil
    
    init(_ player: AVPlayer) {
        self.player = player
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        let stackView = UIStackView(arrangedSubviews: [
            playbackButton,
            slider,
            timeLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = UIStackView.spacingUseSystem
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            playbackButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            rightAnchor.constraint(equalTo: stackView.rightAnchor),
        ])
        
        playbackButton.addAction(UIAction { [unowned self] _ in
            onTapPlaybackButton()
        }, for: .primaryActionTriggered)
        
        addObservePlayback()
        addObserveDuration(player.currentItem!)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            addObserveTime()
        } else {
            removeObserveTime()
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func onTapPlaybackButton() {
        if player.isPaused {
            player.play()
        } else {
            player.pause()
        }
    }
    
    func addObservePlayback() {
        playbackObserver = player.publisher(for: \.rate).sink { [weak self] rate in
            let paused = rate == 0
            self?.playbackButton.configuration = .playback(paused: paused)
        }
    }
    
    func addObserveDuration(_ item: AVPlayerItem) {
        durationObserver = item.publisher(for: \.duration).sink { [weak self] time in
            let maximumValue = Float(time.seconds)
            if maximumValue.isNormal {
                self?.slider.maximumValue = maximumValue
                self?.timeLabel.duration = time
            }
        }
    }
    
    func addObserveTime() {
        let interval = CMTime(
            seconds: CATransaction.animationDuration(),
            preferredTimescale: 600
        )
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: DispatchQueue.main,
            using: { [weak self] time in
                let value = Float(time.seconds)
                if value.isNormal {
                    CATransaction.begin()
                    CATransaction.setAnimationDuration(CATransaction.animationDuration())
                    self?.slider.setValue(value, animated: true)
                    CATransaction.commit()
                    
                    self?.timeLabel.currentTime = time
                }
            }
        )
    }
    
    func removeObserveTime() {
        player.removeTimeObserver(timeObserver)
    }
    
    
}

extension UIButton.Configuration {
    static func playback(paused: Bool = true) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.image = paused ? UIImage(systemName: "play.fill") : UIImage(systemName: "pause.fill")
        return configuration
    }
}

extension AVPlayer {
    var isPaused: Bool { rate == 0 }
}

fileprivate final class TimeLabel: UILabel {
    var currentTime: CMTime = .zero {
        didSet { update() }
    }
    
    var duration: CMTime = .zero {
        didSet { update() }
    }
    
    init() {
        super.init(frame: .null)
        font = .monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        let currentTimeText = string(for: currentTime)
        let durationText = string(for: duration)
        self.text = "\(currentTimeText) / \(durationText)"
    }
    
    func string(for time: CMTime) -> String {
        let duration = time.seconds
        let minutes = Int(duration / 60)
        let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
