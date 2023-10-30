import UIKit

final class PresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(
            forChildContentContainer: presentedViewController,
            withParentContainerSize: containerView!.bounds.size
        )
        return frame
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        containerView!.backgroundColor = .clear
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed {
            containerView!.addSubview(presentedView!)
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            presentedView?.removeFromSuperview()
        }
    }
}
