import UIKit
import os.log

final class InteractiveTransition: NSObject, UIViewControllerInteractiveTransitioning {
    private weak var transitionContext: UIViewControllerContextTransitioning?
    var reversed: Bool = false
    
    func startInteractiveTransition(_ transitionContext: any UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
    }
    
    private var previewControllerView: UIView? {
        guard let transitionContext = transitionContext,
              let previewController = transitionContext.viewController(forKey: .from) as? PreviewController else {
            return nil
        }
        return previewController.internalNavigationController.topViewController?.view
    }
    
    private func animateToPosition(
        transform: CGAffineTransform,
        backgroundColor: UIColor,
        completion: @escaping (Bool) -> Void
    ) {
        guard let transitionContext = transitionContext,
              let view = previewControllerView else {
            completion(true)
            return
        }
        
        UIView.animate(
            withDuration: CATransaction.animationDuration(),
            delay: 0,
            options: .curveEaseOut
        ) {
            view.transform = transform
            transitionContext.containerView.backgroundColor = backgroundColor
        } completion: { finished in
            completion(finished)
        }
    }
    
    func pause() {
        transitionContext?.pauseInteractiveTransition()
    }

    func update(_ percentComplete: CGFloat) {
        guard let transitionContext = transitionContext else { return }
        
        let clampedPercent = max(0.0, min(1.0, percentComplete))
        
        if let view = previewControllerView {
            let translation = transitionContext.containerView.bounds.height * clampedPercent * (reversed ? -1 : 1)
            view.transform = CGAffineTransform(translationX: 0, y: translation)
            transitionContext.containerView.backgroundColor = UIColor.black.withAlphaComponent(1.0 - clampedPercent)
        }
        
        transitionContext.updateInteractiveTransition(clampedPercent)
    }

    func cancel() {
        guard let transitionContext = transitionContext else { return }
        
        transitionContext.cancelInteractiveTransition()
        
        animateToPosition(
            transform: .identity,
            backgroundColor: .black
        ) { _ in
            transitionContext.completeTransition(false)
        }
    }

    func finish() {
        guard let transitionContext = transitionContext else { return }
        
        transitionContext.finishInteractiveTransition()
        
        let finalTranslation = transitionContext.containerView.bounds.height * (reversed ? -1 : 1)
        let finalTransform = CGAffineTransform(translationX: 0, y: finalTranslation)
        
        animateToPosition(
            transform: finalTransform,
            backgroundColor: .clear
        ) { _ in
            transitionContext.completeTransition(true)
        }
    }
}
