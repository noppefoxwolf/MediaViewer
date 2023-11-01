# MediaViewer

## Features

- [x] No dependencies
- [x] Playback video
- [x] Morphing transition
- [x] Waiting for preview with thumbnail
- [x] Custom preview
- [x] Lazy load asset
- [x] Landscape

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/noppefoxwolf/MediaViewer", from: "x.x.x")
],
```

## Usage

### PreviewItem

The ﻿`PreviewItem` is a protocol that provides the behavior necessary for previewing.
`UIImage` and `AVPlayer` have built-in implementations. 
It can also be customized. 

```swift
extension String: PreviewItem {
    public func makeViewController() -> UIViewController {
        UIHostingController(rootView: Text(self))
    }
    
    public func makeThumbnailImage() async -> UIImage? {
        nil
    }
}
```

### PreviewController

`PreviewItem` are displayed using `PreviewController`.
`PreviewController` uses a `PreviewControllerDataSource` to retrieve `PreviewItem`.

```swift
let vc = PreviewController()
vc.delegate = self
vc.dataSource = self
present(vc, animated: true)
```

### PreviewControllerDataSource

```swift
func numberOfPreviewItems(in controller: PreviewController) -> Int
func previewController(_ controller: PreviewController, previewItemAt index: Int) -> any PreviewItem
```

### PreviewControllerDelegate

`PreviewControllerDelegate` supports animations on transitions.

```swift
func previewController(_ controller: PreviewController, transitionViewFor item: any PreviewItem) -> UIView?
```
