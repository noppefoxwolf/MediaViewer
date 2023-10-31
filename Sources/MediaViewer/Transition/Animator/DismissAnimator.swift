import UIKit

final class DismissAnimator: Animator {
    override func interruptibleAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        let nc = transitionContext.viewController(forKey: .from) as? UINavigationController
        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            curve: .linear
        )
        animator.addAnimations {
            transitionContext.containerView.backgroundColor = .clear
            nc?.topViewController?.view.transform = CGAffineTransform(
                translationX: 0,
                y: transitionContext.containerView.bounds.height
            )
        }
        animator.addCompletion { _ in
            let didComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(didComplete)
        }
        return animator
    }
}
