import UIKit

extension UIImage: PreviewItem {
    public func makeViewController() async -> UIViewController {
        ImagePreviewItemViewController(image: self)
    }
    
    public func makeThumbnailViewController() -> UIViewController? {
        ThumbnailViewController(unfolding: { self })
    }
}
