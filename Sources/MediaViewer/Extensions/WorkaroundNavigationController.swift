import UIKit

@MainActor
open class WorkaroundNavigationController: UINavigationController {
    
    // workaround: always use hidesBarsOnTap
    private lazy var tapGesture: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.delegate = self
        return recognizer
    }()
    
    open override var hidesBarsOnTap: Bool {
        get {
            tapGesture.view != nil
        }
        set {
            view.removeGestureRecognizer(tapGesture)
            tapGesture.removeTarget(self, action: #selector(onTap))
            tapGesture.addTarget(self, action: #selector(onTap))
            view.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func onTap(_ gesture: UITapGestureRecognizer) {
        // don't do anything if the tap was on the nav bar or tool bar
        let location = gesture.location(in: view)
        if navigationBar.frame.contains(location) || toolbar.frame.contains(location) {
            return
        }
        setToolbarHidden(!isToolbarHidden, animated: true)
        setNavigationBarHidden(!isNavigationBarHidden, animated: true)
        let hidden = isNavigationBarHidden
        if isDarkMode == false { // only toggle background color on light mode
            UIView.animate(withDuration: 0.2) {
                self.view.backgroundColor = hidden ? .black : .white
            }
        }
    }
    
    // workaround: No re-layout when navigation bar is hidden
    private var _isNavigationBarHidden: Bool = false
    public override var isNavigationBarHidden: Bool {
        get { _isNavigationBarHidden }
        set { _isNavigationBarHidden = newValue }
    }
    
    private var _isToolbarHidden: Bool = false
    public override var isToolbarHidden: Bool {
        get { _isToolbarHidden }
        set { _isToolbarHidden = newValue }
    }
    
    public override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        isNavigationBarHidden = hidden
        let toTransform: CGAffineTransform
        if hidden {
            toTransform = CGAffineTransform(
                translationX: 0,
                y: -(view.safeAreaInsets.top + navigationBar.bounds.height)
            )
        } else {
            toTransform = .identity
        }
        let animator = UIViewPropertyAnimator(
            duration: UINavigationController.hideShowBarDuration,
            curve: .easeInOut
        )
        animator.addAnimations { [weak self] in
            self?.navigationBar.transform = toTransform
        }
        animator.startAnimation()
    }
    
    public override func setToolbarHidden(_ hidden: Bool, animated: Bool) {
        isToolbarHidden = hidden
        let toTransform: CGAffineTransform
        if hidden {
            toTransform = CGAffineTransform(
                translationX: 0,
                y: view.safeAreaInsets.bottom + toolbar.bounds.height
            )
        } else {
            toTransform = .identity
        }
        let animator = UIViewPropertyAnimator(
            duration: UINavigationController.hideShowBarDuration,
            curve: .easeInOut
        )
        animator.addAnimations { [weak self] in
            self?.toolbar.transform = toTransform
        }
        animator.startAnimation()
    }
}

extension WorkaroundNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let doubleTap = otherGestureRecognizer as? UITapGestureRecognizer,
           doubleTap.numberOfTapsRequired == 2 {
            return true
        }
        return false
    }
}
