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

### PreviewController

```swift
let vc = PreviewController()
vc.delegate = self
vc.dataSource = self
present(vc, animated: true)
```

### PreviewItem

The ﻿`PreviewItem` is a protocol that provides the behavior necessary for previewing. 

```swift

```

- UIImage
- AVPlayer

### PreviewControllerDataSource

```swift
func numberOfPreviewItems(in controller: PreviewController) -> Int
func previewController(_ controller: PreviewController, previewItemAt index: Int) -> any PreviewItem
```

### PreviewControllerDelegate

```swift
```
