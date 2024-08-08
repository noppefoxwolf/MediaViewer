import UIKit

@MainActor
public protocol PreviewItem {
    var title: String? { get }
    func makeViewController() async -> UIViewController
    func makeThumbnailViewController() -> UIViewController?
}

@MainActor
extension PreviewItem {
    public var title: String? {
        nil
    }
}
