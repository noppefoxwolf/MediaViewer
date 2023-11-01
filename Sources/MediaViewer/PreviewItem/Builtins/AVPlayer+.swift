import AVKit
import UIKit

extension AVPlayer: PreviewItem {
    public func makeViewController() async -> UIViewController {
        _ = await publisher(for: \.status)
            .filter({ $0 == .readyToPlay })
            .eraseToAnyPublisher()
            .values
            .first(where: { _ in true })
        return PlayerPreviewItemViewController(player: self)
    }
    
    public func makeThumbnailViewController() -> UIViewController? {
        ThumbnailViewController { [weak self] in
            await self?.currentItem?.asset.makeThumbnailImage()
        }
    }
    
    public func makeActivityItemsConfiguration() -> UIActivityItemsConfigurationReading? {
        nil
    }
}
