import UIKit

@MainActor
public protocol PreviewControllerDelegate : AnyObject {
    func previewController(_ controller: PreviewController, transitionViewFor item: any PreviewItem) -> UIView?
    func previewController(_ controller: PreviewController, didMoveTo item: any PreviewItem)
    func previewControllerDidDismiss()
    func previewController(_ controller: PreviewController, willDismissWith item: any PreviewItem)
    func previewControllerDidPresent(_ controller: PreviewController)
}
