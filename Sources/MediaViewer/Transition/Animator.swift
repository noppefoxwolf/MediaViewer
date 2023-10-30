import UIKit

final class PresentAnimator: Animator {
    override func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        let view = transitionContext.view(forKey: .to)!
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                transitionContext.containerView.backgroundColor = .black
            },
            completion: { _ in
                let didComplete = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(didComplete)
            }
        )
    }
}

final class DismissAnimator: Animator {
    override func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        let nc = transitionContext.viewController(forKey: .from) as? UINavigationController
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveLinear,
            animations: {
                transitionContext.containerView.backgroundColor = .clear
                nc?.topViewController?.view.transform = CGAffineTransform(
                    translationX: 0,
                    y: transitionContext.containerView.bounds.height
                )
            },
            completion: { _ in
                let didComplete = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(didComplete)
            }
        )
    }
}

final class ReversedDismissAnimator: Animator {
    override func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        let nc = transitionContext.viewController(forKey: .from) as? UINavigationController
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveLinear,
            animations: {
                transitionContext.containerView.backgroundColor = .clear
                nc?.topViewController?.view.transform = CGAffineTransform(
                    translationX: 0,
                    y: -transitionContext.containerView.bounds.height
                )
            },
            completion: { _ in
                let didComplete = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(didComplete)
            }
        )
    }
}


open class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    open func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        CATransaction.animationDuration()
    }
    
    open func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        
    }
}

