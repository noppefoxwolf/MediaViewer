import UIKit

open class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    open func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        CATransaction.animationDuration()
    }
    
    open func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        interruptibleAnimator(using: transitionContext).startAnimation()
    }
    
    open func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            curve: .linear
        )
    }
}

