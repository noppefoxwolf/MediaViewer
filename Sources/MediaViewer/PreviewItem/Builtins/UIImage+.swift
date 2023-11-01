import UIKit

extension UIImage: PreviewItem {
    public func makeViewController() -> UIViewController {
        ImagePreviewItemViewController(image: self)
    }
    
    public func makeThumbnailImage() async -> UIImage? {
        self
    }
}
