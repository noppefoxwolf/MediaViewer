import UIKit
import MediaViewer

public struct QRCode: PreviewItem {
    public func makeViewController() async -> UIViewController {
        fatalError()
    }
    
    public func makeThumbnailViewController() -> UIViewController? {
        nil
    }
}
