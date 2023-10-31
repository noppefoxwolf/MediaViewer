import UIKit

public protocol PreviewControllerDelegate : AnyObject {
    func previewController(_ controller: PreviewController, frameFor item: any PreviewItem) -> CGRect
    func previewController(_ controller: PreviewController, transitionViewFor item: any PreviewItem) -> UIView?
}
