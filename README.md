# MediaViewer

![](https://github.com/noppefoxwolf/MediaViewer/blob/main/.github/example.gif)

A modern, lightweight media viewer for iOS apps with built-in support for images, videos, and custom content. Features smooth morphing transitions, lazy loading, and a clean UITab-inspired API.

## Features

- [x] **Zero Dependencies** - Pure UIKit implementation
- [x] **Multi-Media Support** - Images, videos, and custom content
- [x] **Morphing Transitions** - Smooth animations between views
- [x] **Async Loading** - Show thumbnails while content loads
- [x] **Custom Content** - Any UIViewController via providers
- [x] **Landscape Support** - Full orientation support
- [x] **Swift 6 Ready** - Modern concurrency and type safety
- [x] **UITab-like API** - Familiar and intuitive design

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/noppefoxwolf/MediaViewer", from: "1.0.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            "MediaViewer",
            "MediaViewerBuiltins" // For convenience initializers
        ]
    )
]
```

## Quick Start

```swift
import MediaViewer
import MediaViewerBuiltins

// Create media pages
let pages = [
    PreviewPage(image: UIImage(named: "photo")!),
    PreviewPage(player: AVPlayer(url: videoURL)),
    PreviewPage(viewControllerProvider: {
        UIHostingController(rootView: Text("Custom Content"))
    })
]

// Present media viewer
let previewController = PreviewController()
previewController.previewPages = pages
previewController.currentPreviewItemIndex = 0
present(previewController, animated: true)
```

## API Reference

### PreviewPage

The core class representing content to be previewed. Conforms to `Identifiable`, `Equatable`, and `Hashable`.

#### Convenience Initializers (MediaViewerBuiltins)

```swift
// Images - uses optimized ImagePreviewItemViewController
let imagePage = PreviewPage(image: UIImage(named: "photo")!)

// Videos - uses PlayerPreviewItemViewController
let videoPage = PreviewPage(player: AVPlayer(url: videoURL))
```

#### Custom Content

```swift
let customPage = PreviewPage(
    id: UUID(), // Optional custom ID
    viewControllerProvider: {
        // Main content - called when page becomes visible
        try await Task.sleep(for: .seconds(1)) // Simulate loading
        return UIHostingController(rootView: YourCustomView())
    },
    thumbnailProvider: { // Optional
        // Thumbnail shown during loading
        UIHostingController(rootView: Text("Loading..."))
    },
    activityProvider: { // Optional
        // Share/activity items
        UIActivityItemsConfiguration(objects: ["Share this content"])
    }
)
```

### PreviewController

Displays PreviewPage objects with navigation and transitions.

```swift
let controller = PreviewController()
controller.delegate = self
controller.previewPages = pages
controller.currentPreviewItemIndex = selectedIndex
present(controller, animated: true)
```

#### Properties

- `previewPages: [PreviewPage]` - Array of pages to display
- `currentPreviewItemIndex: Int` - Currently visible page index
- `delegate: PreviewControllerDelegate?` - Delegate for transitions

### PreviewControllerDelegate

Supports smooth transitions between your UI and the media viewer.

```swift
extension YourViewController: PreviewControllerDelegate {
    func previewController(_ controller: PreviewController, transitionViewFor page: PreviewPage) -> UIView? {
        // Return the view to animate from (e.g., collection view cell)
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return nil }
        return collectionView.cellForItem(at: indexPath)
    }
}
```

## Requirements

- iOS 17.0+
- Swift 6.2+
- Xcode 15.0+

## Apps Using MediaViewer

<p float="left">
    <a href="https://apps.apple.com/app/id1668645019"><img src="https://github.com/noppefoxwolf/markdown-resources/blob/main/app-icons/dev.noppe.snowfox.png" height="65"></a>
</p>

If your app uses MediaViewer, please add it via Pull Request!

## License

MIT License. See [LICENSE](LICENSE) for details.
