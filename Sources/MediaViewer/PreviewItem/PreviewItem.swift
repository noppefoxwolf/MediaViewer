import UIKit

@MainActor
public protocol PreviewItem {
    var title: String? { get }
    var onLoadError: ((Error) -> Void)? { get }
    func makeViewController() async throws -> UIViewController
    func makeErrorViewController() -> UIViewController
    func makeThumbnailViewController() -> UIViewController?
}

@MainActor
extension PreviewItem {
    public var title: String? {
        nil
    }
}
