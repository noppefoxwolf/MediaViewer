import UIKit

public protocol PreviewItem {
    @MainActor
    func makeViewController() async -> UIViewController
    
    @MainActor
    func makeThumbnailViewController() -> UIViewController?
    
    @MainActor
    func makeActivityItemsConfiguration() -> UIActivityItemsConfigurationReading?
}

extension PreviewItem {
    public func makeActivityItemsConfiguration() -> UIActivityItemsConfigurationReading? {
        nil
    }
}
