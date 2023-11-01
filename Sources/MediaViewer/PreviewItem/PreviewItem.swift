import UIKit

public protocol PreviewItem {
    associatedtype AsyncSequenceType: AsyncSequence
    func makeViewController() -> UIViewController
    func makeThumbnailImage() async -> UIImage?
    func makeActivityItemsConfiguration() -> UIActivityItemsConfigurationReading?
    var readyToPreview: AsyncSequenceType { get }
}

extension PreviewItem {
    public func makeActivityItemsConfiguration() -> UIActivityItemsConfigurationReading? { nil }
    public var readyToPreview: some AsyncSequence {
        AsyncStream(unfolding: {})
    }
}
