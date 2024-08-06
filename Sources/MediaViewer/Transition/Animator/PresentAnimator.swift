import UIKit

final class PresentAnimator: Animator {
    override func interruptibleAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        
        let previewController = transitionContext.viewController(forKey: .to) as! PreviewController
        let container = transitionContext.containerView
        
        let duration = transitionDuration(using: transitionContext)
        let animator = UIViewPropertyAnimator(
            duration: duration,
            dampingRatio: 0.82
        )
        
        guard let transitionView = previewController.currentTransitionView,
              let transitionImageView = container.viewWithTag(602),
              let background = container.viewWithTag(601),
              let topView = previewController.topView else {
            animator.addAnimations {
                previewController.topView?.alpha = 1
                previewController.internalNavigationController.navigationBar.alpha = 1.0
            }
            animator.addCompletion { _ in
                previewController.currentTransitionView?.alpha = 1
                let didComplete = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(didComplete)
            }
            return animator
        }
        
        animator.addAnimations {
            background.alpha = 1.0
            previewController.internalNavigationController.navigationBar.alpha = 1.0
            transitionImageView.frame = container.bounds
        }
        
        animator.addCompletion { _ in
            topView.alpha = 1
            previewController.currentTransitionView?.alpha = 1
            transitionImageView.removeFromSuperview()
            let didComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(didComplete)
        }
        
        return animator
        
    }
}
