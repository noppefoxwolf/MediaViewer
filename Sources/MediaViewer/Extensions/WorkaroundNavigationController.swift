import UIKit

open class WorkaroundNavigationController: UINavigationController {
    
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
        UIView.animate(
            withDuration: UINavigationController.hideShowBarDuration,
            delay: 0,
            options: .beginFromCurrentState,
            animations: { [unowned self] in
                navigationBar.transform = toTransform
            }
        )
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
        UIView.animate(
            withDuration: UINavigationController.hideShowBarDuration,
            delay: 0,
            options: .beginFromCurrentState,
            animations: { [unowned self] in
                toolbar.transform = toTransform
            }
        )
    }
}
