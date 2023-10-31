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
    
    var transitionView: UIView? = nil
    override func presentationTransitionWillBegin() {
        transitionView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        transitionView!.backgroundColor = .red
        containerView!.addSubview(transitionView!)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed {
            containerView!.addSubview(presentedView!)
            transitionView?.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            presentedView?.removeFromSuperview()
        }
    }
}
