import UIKit

final class PresentationController: UIPresentationController {
    override func presentationTransitionWillBegin() {
        containerView?.backgroundColor = .clear
        containerView?.addSubview(presentedView!)
        let previewController = presentedViewController as! PreviewController
        
        previewController
            .topView?
            .alpha = 0
        
        let fromTransition: CGAffineTransform
        let fromScale: Double
        let transitionView = previewController.currentTransitionView
        if let containerView, let transitionView {
            let point = transitionView
                .convert(transitionView.bounds, to: containerView)
                .applying(.init(
                    translationX: -containerView.center.x,
                    y: -containerView.center.y
                ))
            fromTransition = CGAffineTransform(translationX: point.midX, y: point.midY)
            fromScale = transitionView.bounds.width / containerView.bounds.width
        } else {
            fromTransition = .identity
            fromScale = 0.85
        }
        previewController
            .topView?
            .transform = fromTransition.scaledBy(x: fromScale, y: fromScale)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            presentedView?.removeFromSuperview()
        }
    }
}
