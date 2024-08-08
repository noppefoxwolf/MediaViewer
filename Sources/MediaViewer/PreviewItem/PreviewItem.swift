import UIKit

public protocol PreviewItem {
    @MainActor
    var title: String? { get }
    
    @MainActor
    func makeViewController() async -> UIViewController
    
    @MainActor
    func makeThumbnailViewController() -> UIViewController?
}

extension PreviewItem {
    public var title: String? {
        nil
    }
}
