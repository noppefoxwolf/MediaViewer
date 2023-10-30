import UIKit
import AVKit

public protocol PreviewItem {
    associatedtype ViewControllerType: UIViewController
    func makeViewController() -> ViewControllerType
    func makeActivityItemsConfiguration() -> UIActivityItemsConfigurationReading?
}

extension PreviewItem {
    public func makeActivityItemsConfiguration() -> UIActivityItemsConfigurationReading? { nil }
}

extension UIImage: PreviewItem {
    public func makeViewController() -> some UIViewController {
        ImagePreviewItemViewController(image: self)
    }
}

extension AVPlayer: PreviewItem {
    public func makeViewController() -> some UIViewController {
        PlayerPreviewItemViewController(player: self)
    }
}
