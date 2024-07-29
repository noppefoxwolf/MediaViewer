import UIKit

final class Presenter: NSObject, UIViewControllerTransitioningDelegate {
    var interactiveTransition: InteractiveTransition? = nil
    var reversedDismiss: Bool = false
    
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
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        PresentAnimator()
    }
    
    func animationController(
        forDismissed dismissed: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        reversedDismiss ? ReversedDismissAnimator() : DismissAnimator()
    }
    
    func interactionControllerForDismissal(
        using animator: any UIViewControllerAnimatedTransitioning
    ) -> (any UIViewControllerInteractiveTransitioning)? {
        interactiveTransition
    }
}

