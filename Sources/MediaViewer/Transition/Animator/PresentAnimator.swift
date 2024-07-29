import UIKit

final class PresentAnimator: Animator {
    override func interruptibleAnimator(
        using transitionContext: any UIViewControllerContextTransitioning
    ) -> any UIViewImplicitlyAnimating {
        let previewController = transitionContext.viewController(forKey: .to) as! PreviewController
        
        let duration = transitionDuration(using: transitionContext)
        let animator = UIViewPropertyAnimator(
            duration: duration,
            dampingRatio: 0.82
        )
        animator.addAnimations {
            previewController
                .currentTransitionView?
                .alpha = 0
        }
        animator.addAnimations {
            transitionContext.containerView.backgroundColor = .black
        }
        animator.addAnimations {
            previewController
                .topView?
                .alpha = 1
        }
        animator.addAnimations {
            previewController
                .topView?
                .transform = .identity
        }
        animator.addCompletion { _ in
            previewController
                .currentTransitionView?
                .alpha = 1
            let didComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(didComplete)
        }
        return animator
    }
}
