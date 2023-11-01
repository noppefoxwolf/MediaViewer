import UIKit

extension UIImage: PreviewItem {
    public func makeViewController() async -> UIViewController {
        ImagePreviewItemViewController(image: self)
    }
    
    public func makeThumbnailViewController() -> UIViewController? {
        ThumbnailViewController(unfolding: { self })
    }
    
    public func makeActivityItemsConfiguration() -> UIActivityItemsConfigurationReading? {
        let configuration = UIActivityItemsConfiguration(objects: [self])
        configuration.previewProvider = { (_, _, _) in
            NSItemProvider(object: self)
        }
        return configuration
    }
}
