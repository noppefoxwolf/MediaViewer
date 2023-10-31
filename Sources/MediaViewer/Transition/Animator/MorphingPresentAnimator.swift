import UIKit

final class MorphingPresentAnimator: Animator {
    override func interruptibleAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        let view = transitionContext.view(forKey: .to)!
        let morphingView = transitionContext.containerView.viewWithTag(1234)!
        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext) * 50,
            curve: .linear
        )
        animator.addAnimations {
            transitionContext.containerView.backgroundColor = .black
        }
        animator.addAnimations {
            morphingView.frame = transitionContext.containerView.bounds
        }
        animator.addAnimations {
            morphingView.contentMode = .scaleAspectFit
        }
        animator.addCompletion { _ in
            let didComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(didComplete)
        }
        return animator
    }
}
