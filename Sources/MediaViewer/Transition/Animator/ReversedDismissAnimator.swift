import UIKit

final class ReversedDismissAnimator: Animator {
    override func interruptibleAnimator(
        using transitionContext: any UIViewControllerContextTransitioning
    ) -> any UIViewImplicitlyAnimating {
        let previewController = transitionContext.viewController(forKey: .from) as! PreviewController
        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            curve: .linear
        )
        animator.addAnimations {
            transitionContext.containerView.backgroundColor = .clear
            previewController
                .internalNavigationController
                .topViewController?
                .view
                .transform = CGAffineTransform(
                    translationX: 0,
                    y: -transitionContext.containerView.bounds.height
                )
        }
        animator.addCompletion { _ in
            let didComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(didComplete)
        }
        return animator
    }
}
