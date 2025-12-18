public import UIKit

@MainActor
public protocol PreviewControllerDelegate : AnyObject {
    func previewController(_ controller: PreviewController, transitionViewFor page: PreviewPage) -> UIView?
}
