import UIKit

final class PresentationController: UIPresentationController {
    override func presentationTransitionWillBegin() {
        containerView?.backgroundColor = .clear
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed {
            containerView?.addSubview(presentedView!)
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            presentedView?.removeFromSuperview()
        }
    }
}
