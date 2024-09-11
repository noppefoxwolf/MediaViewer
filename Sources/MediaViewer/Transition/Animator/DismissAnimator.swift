import UIKit

@MainActor
final class DismissAnimator: Animator {
    
    var onDismissed: (() -> Void)?
    
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
              let toControllerView = transitionContext.viewController(forKey: .to)?.view,
              let fromControllerView = transitionContext.viewController(forKey: .from)?.view,
              let toTransitionView = previewController.currentTransitionView,
              let topView = previewController.topView else {
            
            previewController.currentTransitionView?.isHidden = false
            previewController.currentTransitionView?.alpha = 1.0
            
            animator.addAnimations {
                container.viewWithTag(PresentationConsts.transitionViewTag)?.alpha = 0.0
                transitionContext.viewController(forKey: .from)?.view.alpha = 0.0
            }
            
            animator.addCompletion { _ in
                let didComplete = !transitionContext.transitionWasCancelled
                if didComplete {
                    self.onDismissed?()
                } else {
                    container.viewWithTag(PresentationConsts.transitionViewTag)?.removeFromSuperview()
                    transitionContext.viewController(forKey: .from)?.view.alpha = 1.0
                    previewController.topView?.alpha = 1.0
                }
                transitionContext.completeTransition(didComplete)
            }
            return animator
        }
        
        let targetFrame = toTransitionView.convert(toTransitionView.bounds, to: container)

        animator.addAnimations {
            fromTransitionView.frame = targetFrame
            fromControllerView.alpha = 0.0
        }
        
        animator.addCompletion { _ in
            fromTransitionView.removeFromSuperview()
            let didComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(didComplete)
            if didComplete {
                toTransitionView.alpha = 1.0
                // it's ok to hold a strong reference here as the completion block is guarenteed to be called
                // and this reference is actually what's holding it until this point.
                self.onDismissed?()
            } else {
                toTransitionView.alpha = 1.0
                previewController.topView?.alpha = 1.0
                fromControllerView.alpha = 1.0
            }
        }
        
        return animator
    }
}
