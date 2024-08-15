import UIKit

struct PresentationConsts {
    static let transitionViewTag = 602
    static let backgroundViewTag = 601
}

@MainActor
final class PresentationController: UIPresentationController {
    
    var onWillDismiss:(() -> Void)?
    
    override func presentationTransitionWillBegin() {
        
        guard let previewController = presentedViewController as? PreviewController,
              let containerView,
              let transitionView = previewController.currentTransitionView,
              let topView = previewController.topView else { return }
        
        containerView.backgroundColor = .clear
        containerView.addSubview(presentedView!)

        previewController.topView?.alpha = 0.0
        
        let transitionImage: UIImage?
        if let cgImage = (transitionView as? UIImageView)?.image?.cgImage {
            transitionImage = UIImage(cgImage: cgImage)
        } else {
            let renderer = UIGraphicsImageRenderer(bounds: transitionView.bounds)
            transitionImage = renderer.image { rendererContext in
                transitionView.layer.render(in: rendererContext.cgContext)
            }
        }
        
        let transitionImageView = UIImageView(image: transitionImage)
        transitionImageView.tag = PresentationConsts.transitionViewTag
        transitionImageView.contentMode = .scaleAspectFill
        
        transitionImageView.clipsToBounds = true
        transitionView.alpha = 0.0
        
        let navController = previewController.internalNavigationController
        navController.view.addSubview(transitionImageView)
        navController.view.bringSubviewToFront(navController.navigationBar)
        navController.view.bringSubviewToFront(navController.toolbar)
        transitionImageView.frame = transitionView.convert(transitionView.bounds,
                                                           to: navController.view)
        
        containerView.bringSubviewToFront(presentedView!)
        
    }
    
    override func dismissalTransitionWillBegin() {
        
        guard let previewController = presentedViewController as? PreviewController,
              let dismissedController = previewController.currentViewController as? DismissTransitionViewProviding,
              let dismissedView = dismissedController.viewForDismissTransition,
              let containerView else { return }
                
        let transitionImage: UIImage?
        if let cgImage = (dismissedView as? UIImageView)?.image?.cgImage {
            transitionImage = UIImage(cgImage: cgImage)
        } else {
            let renderer = UIGraphicsImageRenderer(bounds: dismissedView.bounds)
            transitionImage = renderer.image { rendererContext in
                dismissedView.layer.render(in: rendererContext.cgContext)
            }
        }
        
        let transitionImageView = UIImageView(image: transitionImage)
        transitionImageView.tag = PresentationConsts.transitionViewTag
        transitionImageView.contentMode = .scaleAspectFill
        
        containerView.addSubview(transitionImageView)
        transitionImageView.frame = dismissedView.convert(dismissedView.bounds, to: containerView)
        transitionImageView.clipsToBounds = true
       
        previewController.topView?.alpha = 0.0
        
        if let transitionView = previewController.currentTransitionView {
            transitionView.alpha = 0.0
            transitionView.setNeedsDisplay()
            transitionView.layoutIfNeeded()
            CATransaction.flush()
        }
                
        onWillDismiss?()
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            presentedView?.removeFromSuperview()
        }
    }
}
