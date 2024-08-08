import UIKit

struct PresentationConsts {
    static let transitionViewTag = 602
    static let backgroundViewTag = 601
}

final class PresentationController: UIPresentationController {
    
    override func presentationTransitionWillBegin() {
        
        guard let previewController = presentedViewController as? PreviewController,
              let containerView,
              let transitionView = previewController.currentTransitionView,
              let topView = previewController.topView else { return }
        
        containerView.backgroundColor = .clear
        containerView.addSubview(presentedView!)

        previewController.internalNavigationController.navigationBar.alpha = 0.0
        previewController.topView?.alpha = 0.0
        
        let backgroundView = UIView()
        backgroundView.tag = PresentationConsts.backgroundViewTag
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.0
        containerView.addSubview(backgroundView)
        backgroundView.frame = containerView.bounds
        
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
        transitionImageView.contentMode = .scaleAspectFit
    
        containerView.addSubview(transitionImageView)
        transitionImageView.frame = transitionView.convert(transitionView.bounds, to: containerView)
        transitionView.alpha = 0.0
        
        containerView.sendSubviewToBack(transitionView)
        containerView.sendSubviewToBack(backgroundView)
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
        previewController.currentTransitionView?.isHidden = true
        previewController.topView?.alpha = 0.0
        
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            presentedView?.removeFromSuperview()
        }
    }
}
