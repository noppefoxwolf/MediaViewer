public import UIKit

open class WorkaroundNavigationController: UINavigationController {
    
    // workaround: always use hidesBarsOnTap
    private let tapGesture = UITapGestureRecognizer()
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
        setToolbarHidden(!isToolbarHidden, animated: true)
        setNavigationBarHidden(!isNavigationBarHidden, animated: true)
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
        guard isNavigationBarHidden != hidden else { return }
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
        animator.addCompletion { [weak self] _ in
            DispatchQueue.main.async {
                self?.isNavigationBarHidden = hidden
            }
        }
        animator.startAnimation()
    }
    
    public override func setToolbarHidden(_ hidden: Bool, animated: Bool) {
        guard isToolbarHidden != hidden else { return }
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
            DispatchQueue.main.async {
                self?.toolbar.transform = toTransform
            }
        }
        animator.addCompletion { [weak self] _ in
            DispatchQueue.main.async {
                self?.isToolbarHidden = hidden
            }
        }
        animator.startAnimation()
    }
}
