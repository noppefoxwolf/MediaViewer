import UIKit
import SwiftUI
import AVKit
import Combine
import MediaViewer

// Convenience initializers using MediaViewerBuiltins components
extension PreviewPage {
    public convenience init(id: UUID = UUID(), image: UIImage) {
        self.init(
            id: id,
            viewControllerProvider: {
                ImagePreviewItemViewController(image: image)
            },
            thumbnailViewControllerProvider: {
                ThumbnailViewController(unfolding: { image })
            },
            activityProvider: {
                let configuration = UIActivityItemsConfiguration(objects: [image])
                configuration.previewProvider = { (_, _, _) in
                    NSItemProvider(object: image)
                }
                return configuration
            }
        )
    }
    
    public convenience init(id: UUID = UUID(), player: AVPlayer) {
        self.init(
            id: id,
            viewControllerProvider: {
                PlayerPreviewItemViewController(player: player)
            },
            thumbnailViewControllerProvider: { [weak player] in
                ThumbnailViewController { [weak player] in
                    await player?.currentItem?.asset.makeThumbnailImage()
                }
            }
        )
    }
}
