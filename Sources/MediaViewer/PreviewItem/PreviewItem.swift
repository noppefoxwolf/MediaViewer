import UIKit
import AVKit

public protocol PreviewItem {
    associatedtype ViewControllerType: UIViewController
    associatedtype AsyncSequenceType: AsyncSequence
    func makeViewController() -> ViewControllerType
    func makeActivityItemsConfiguration() -> UIActivityItemsConfigurationReading?
    var readyToPlay: AsyncSequenceType { get }
}

public enum ThumbnailResource {
    case url(URL)
    case image(UIImage)
}

extension PreviewItem {
    public func makeActivityItemsConfiguration() -> UIActivityItemsConfigurationReading? { nil }
}

extension UIImage: PreviewItem {
    public func makeViewController() -> some UIViewController {
        ImagePreviewItemViewController(image: self)
    }
    
    public var readyToPlay: AsyncStream<Void> {
        AsyncStream<Void>(unfolding: {
            try! await Task.sleep(for: .seconds(2))
        })
    }
}

extension AVPlayer: PreviewItem {
    public func makeViewController() -> some UIViewController {
        PlayerPreviewItemViewController(player: self)
    }
    
    public var readyToPlay: some AsyncSequence {
        publisher(for: \.status)
            .delay(for: 1, scheduler: DispatchQueue.main)
            .filter({ $0 == .readyToPlay })
            .eraseToAnyPublisher()
            .values
    }
}
