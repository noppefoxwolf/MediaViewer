import UIKit

final class DismissAnimator: Animator {
    override func interruptibleAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        let previewController = transitionContext.viewController(forKey: .from) as! PreviewController
        let container = transitionContext.containerView
        
        let duration = transitionDuration(using: transitionContext)
        let animator = UIViewPropertyAnimator(
            duration: duration,
            dampingRatio: 0.82
        )
        
        guard let fromTransitionView = container.viewWithTag(PresentationConsts.transitionViewTag),
              let toTransitionView = previewController.currentTransitionView,
              let background = container.viewWithTag(PresentationConsts.backgroundViewTag),
              let topView = previewController.topView else {
            animator.addAnimations {
                transitionContext.containerView.backgroundColor = .clear
                previewController.topView?.alpha = 0.0
            }
            animator.addCompletion { _ in
                let didComplete = !transitionContext.transitionWasCancelled
                if !didComplete {
                    previewController.internalNavigationController.navigationBar.alpha = 1.0
                    previewController.topView?.alpha = 1.0
                }
                transitionContext.completeTransition(didComplete)
            }
            return animator
        }
        
        let targetFrame = toTransitionView.convert(toTransitionView.bounds, to: container)
        
        animator.addAnimations {
            background.alpha = 0.0
            previewController.internalNavigationController.navigationBar.alpha = 0.0
            fromTransitionView.frame = targetFrame
        }
        
        animator.addAnimations({
            fromTransitionView.alpha = 0.0
        }, delayFactor: 0.5)
        
        animator.addCompletion { _ in
            fromTransitionView.removeFromSuperview()
            let didComplete = !transitionContext.transitionWasCancelled
            if !didComplete {
                background.alpha = 1.0
                previewController.internalNavigationController.navigationBar.alpha = 1.0
                previewController.topView?.alpha = 1.0
            }
            transitionContext.completeTransition(didComplete)
        }
        
        return animator
    }
}
