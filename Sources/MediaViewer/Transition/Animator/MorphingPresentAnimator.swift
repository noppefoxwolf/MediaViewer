import UIKit

final class MorphingPresentAnimator: Animator {
    override func interruptibleAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        let view = transitionContext.view(forKey: .to)!
        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext) * 50,
            curve: .linear
        )
        animator.addAnimations {
            transitionContext.containerView.backgroundColor = .black
        }
        animator.addCompletion { _ in
            let didComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(didComplete)
        }
        return animator
    }
}
