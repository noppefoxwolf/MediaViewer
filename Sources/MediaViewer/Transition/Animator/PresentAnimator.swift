import UIKit
import AVFoundation

@MainActor
final class PresentAnimator: Animator {
    override func interruptibleAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        
        let previewController = transitionContext.viewController(forKey: .to) as! PreviewController
        let fromController = transitionContext.viewController(forKey: .from)
        let container = transitionContext.containerView
        
        let duration = transitionDuration(using: transitionContext)
        let animator = UIViewPropertyAnimator(
            duration: duration,
            dampingRatio: 0.82
        )
        
        guard let transitionView = previewController.currentTransitionView,
              let transitionImageView = container.viewWithTag(PresentationConsts.transitionViewTag) as? UIImageView,
              let transitionImage = transitionImageView.image,
              let fromView = fromController?.view,
              let topView = previewController.topView else {
            
            container.viewWithTag(PresentationConsts.transitionViewTag)?.removeFromSuperview()
            
            animator.addAnimations {
                previewController.topView?.alpha = 1
            }
            animator.addCompletion { _ in
                previewController.currentTransitionView?.alpha = 1
                let didComplete = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(didComplete)
            }
            return animator
        }
        
        let targetRect = AVMakeRect(aspectRatio: transitionImage.size, insideRect: container.bounds)
        
        animator.addAnimations {
            transitionImageView.frame = targetRect
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
