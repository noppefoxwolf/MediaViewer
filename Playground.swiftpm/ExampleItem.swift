import AVFoundation
import MediaViewer
import MediaViewerBuiltins
import SwiftUI
import UIKit

enum ExampleItem: Hashable, Identifiable {
    case image(UIImage, String)
    case video(URL, String)
    case text(String)
    case failed

    var id: String {
        switch self {
        case .image(_, let title), .video(_, let title):
            title
        case .text(let text):
            text
        case .failed:
            "failed"
        }
    }

    var title: String {
        switch self {
        case .image(_, let title), .video(_, let title):
            title
        case .text(let text):
            text
        case .failed:
            "Failed"
        }
    }

    var mediaPage: PreviewPage {
        switch self {
        case .image(let image, _):
            PreviewPage(image: image)
        case .video(let url, _):
            PreviewPage(player: AVPlayer(url: url))
        case .text(let text):
            PreviewPage(
                viewControllerProvider: {
                    try! await Task.sleep(for: .seconds(1))
                    return UIHostingController(rootView: Text(text).font(.title))
                },
                thumbnailViewControllerProvider: {
                    UIHostingController(rootView: ProgressView())
                }
            )
        case .failed:
            PreviewPage(player: AVPlayer(url: URL(string: "https://example.com")!))
        }
    }

    static let samples: [ExampleItem] = [
        .image(UIImage(resource: .image1), "Photo 1"),
        .image(UIImage(resource: .image2), "Photo 2"),
        .video(URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/adv_dv_atmos/main.m3u8")!, "Sample Video"),
        .text("Hello, World!"),
        .failed
    ]
}
