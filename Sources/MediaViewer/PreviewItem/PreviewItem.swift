import UIKit

public protocol PreviewItem {
    @MainActor
    var title: String? { get }
    
    @MainActor
    func makeViewController() async -> UIViewController
    
    @MainActor
    func makeThumbnailViewController() -> UIViewController?
    
    @MainActor
    func makeActivityItemsConfiguration() -> (any UIActivityItemsConfigurationReading)?
}

extension PreviewItem {
    public var title: String? {
        nil
    }
    public func makeActivityItemsConfiguration() -> (any UIActivityItemsConfigurationReading)? {
        nil
    }
}
