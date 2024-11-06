public import AVKit
import UIKit

extension AVPlayer: PreviewItem {
    
    public nonisolated func makeViewController() async -> UIViewController {
        _ = await publisher(for: \.status)
            .values
            .first(where: { $0 == .readyToPlay })
        return await PlayerPreviewItemViewController(player: self)
    }
    
    public func makeThumbnailViewController() -> UIViewController? {
        ThumbnailViewController { [weak self] in
            await self?.currentItem?.asset.makeThumbnailImage()
        }
    }
    
    public func makeActivityItemsConfiguration() -> (any UIActivityItemsConfigurationReading)? {
        nil
    }
}
