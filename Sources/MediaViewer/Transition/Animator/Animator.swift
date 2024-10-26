public import UIKit

open class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    open func transitionDuration(
        using transitionContext: (any UIViewControllerContextTransitioning)?
    ) -> TimeInterval {
        CATransaction.animationDuration()
    }
    
    open func animateTransition(
        using transitionContext: any UIViewControllerContextTransitioning
    ) {
        interruptibleAnimator(using: transitionContext).startAnimation()
    }
    
    open func interruptibleAnimator(using transitionContext: any UIViewControllerContextTransitioning) -> any UIViewImplicitlyAnimating {
        UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            curve: .linear
        )
    }
}

