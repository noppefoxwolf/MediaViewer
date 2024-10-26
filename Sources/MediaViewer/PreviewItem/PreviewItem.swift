public import UIKit

public protocol PreviewItem {
    @MainActor
    func makeViewController() async -> UIViewController
    
    @MainActor
    func makeThumbnailViewController() -> UIViewController?
    
    @MainActor
    func makeActivityItemsConfiguration() -> (any UIActivityItemsConfigurationReading)?
}

extension PreviewItem {
    public func makeActivityItemsConfiguration() -> (any UIActivityItemsConfigurationReading)? {
        nil
    }
}
