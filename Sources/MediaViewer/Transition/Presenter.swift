import UIKit

@MainActor
final class Presenter: NSObject, UIViewControllerTransitioningDelegate {
    var interactiveTransition: InteractiveTransition? = nil
    var reversedDismiss: Bool = false
    var onDismissed: (() -> Void)?
    
    init(onDismissed: (() -> Void)? = nil) {
        self.onDismissed = onDismissed
        super.init()
    }
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        PresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        PresentAnimator()
    }
    
    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        let animator = DismissAnimator()
        animator.onDismissed = onDismissed
        return animator
    }
    
    func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        interactiveTransition
    }
}

