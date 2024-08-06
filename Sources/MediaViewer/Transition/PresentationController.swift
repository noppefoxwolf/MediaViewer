import UIKit

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
        backgroundView.tag = 601
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
        transitionImageView.tag = 602
        transitionImageView.contentMode = .scaleAspectFit
    
        containerView.addSubview(transitionImageView)
        transitionImageView.frame = transitionView.convert(transitionView.bounds, to: containerView)
        
        previewController.currentTransitionView?.alpha = 0
        
        containerView.sendSubviewToBack(transitionView)
        containerView.sendSubviewToBack(backgroundView)
        containerView.bringSubviewToFront(presentedView!)
        
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            presentedView?.removeFromSuperview()
        }
    }
}
