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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        super.setToolbarHidden(false, animated: false)
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
            MainActor.assumeIsolated {
                self?.isNavigationBarHidden = hidden
            }
        }
        animator.startAnimation()
    }
    
    
    var isGlassStyleToolbar: Bool {
        // <_TtGC5UIKit17UICoreHostingViewVCS_21ToolbarVisualProvider8RootView_: 0x102825740; frame = (0 0; 0 0); layer = <CALayer: 0x600000c60db0>>
        toolbar.subviews.first?.bounds.isEmpty == true
    }
    
    public override func setToolbarHidden(_ hidden: Bool, animated: Bool) {
        if isGlassStyleToolbar {
            super.setToolbarHidden(hidden, animated: animated)
            isToolbarHidden = hidden
        } else {
            setToolbarItemsManually(hidden, animated: animated)
        }
    }
    
    func setToolbarItemsManually(_ hidden: Bool, animated: Bool) {
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
            self?.toolbar.transform = toTransform
        }
        animator.addCompletion { [weak self] _ in
            MainActor.assumeIsolated {
                self?.isToolbarHidden = hidden
            }
        }
        animator.startAnimation()
    }
}
