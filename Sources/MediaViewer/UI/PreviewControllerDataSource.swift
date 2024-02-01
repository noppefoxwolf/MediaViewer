import UIKit
import QuickLook

@MainActor
public protocol PreviewControllerDataSource: AnyObject {
    func numberOfPreviewItems(in controller: PreviewController) -> Int
    func previewController(_ controller: PreviewController, previewItemAt index: Int) -> any PreviewItem
}

