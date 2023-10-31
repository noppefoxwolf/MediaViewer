import UIKit

final class MorphingPresentAnimator: Animator {
    let morphingView: UIView
    
    init(morphingView: UIView) {
        self.morphingView = morphingView
        super.init()
    }
    
    override func interruptibleAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        let view = transitionContext.view(forKey: .to)!
        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            curve: .linear
        )
        animator.addAnimations {
            transitionContext.containerView.backgroundColor = .black
        }
        animator.addAnimations { [weak self] in
            self?.morphingView.frame = transitionContext.containerView.bounds
        }
        animator.addCompletion { _ in
            let didComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(didComplete)
        }
        return animator
    }
}
