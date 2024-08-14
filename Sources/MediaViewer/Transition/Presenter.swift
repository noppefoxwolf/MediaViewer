import UIKit

@MainActor
final class Presenter: NSObject, UIViewControllerTransitioningDelegate {
    var interactiveTransition: InteractiveTransition? = nil
    var reversedDismiss: Bool = false
    var onDismissed: (() -> Void)?
    var onWillDismiss:(() -> Void)?
    
    init(onWillDismiss:(() -> Void)? = nil,
         onDismissed: (() -> Void)? = nil) {
        self.onDismissed = onDismissed
        self.onWillDismiss = onWillDismiss
        super.init()
    }
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let controller = PresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
        controller.onWillDismiss = onWillDismiss
        return controller
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

