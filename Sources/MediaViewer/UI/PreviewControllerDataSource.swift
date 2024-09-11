import UIKit
import QuickLook

@MainActor
public protocol PreviewControllerDataSource: AnyObject {
    func previewController(_ controller: PreviewController, previewItemsBefore item: any PreviewItem) async -> [any PreviewItem]
    func previewController(_ controller: PreviewController, previewItemsAfter item: any PreviewItem) async -> [any PreviewItem]
    func activityItems(for item: PreviewItem) async -> [Any]?
}

