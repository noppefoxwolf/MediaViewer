import UIKit

public final class PreviewController: WorkaroundNavigationController {
    
    private let presenter = Presenter()
    
    public weak var dataSource: PreviewControllerDataSource? = nil
    
    var wasToolbarHidden: Bool = false
    
    let pageViewController = PageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: [.interPageSpacing : UIStackView.spacingUseSystem]
    )
    
    public var currentPreviewItemIndex: Int = 0
    
    public func refreshCurrentPreviewItem() {
        let item = dataSource?.previewController(
            self,
            previewItemAt: currentPreviewItemIndex
        )
        if let item {
            let vc = PreviewItemViewController(
                item,
                index: currentPreviewItemIndex
            )
            pageViewController.setViewControllers(
                [vc],
                direction: .forward,
                animated: false
            )
        }
    }
    
    public init() {
        super.init(
            navigationBarClass: UINavigationBar.self,
            toolbarClass: Toolbar.self
        )
        transitioningDelegate = presenter
        modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setViewControllers([pageViewController], animated: false)
        setNavigationBarHidden(false, animated: false)
        setToolbarHidden(false, animated: false)
        
        navigationBar.standardAppearance.configureWithTransparentBackground()
        navigationBar.tintColor = .white
        
        toolbar.standardAppearance = UIToolbarAppearance()
        toolbar.standardAppearance.configureWithTransparentBackground()
        toolbar.tintColor = .white
        
        hidesBarsOnTap = true
        
        refreshCurrentPreviewItem()
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.uiDelegate = self
        
        let panGesture = UIPanGestureRecognizer()
        panGesture.delegate = self
        panGesture.addTarget(self, action: #selector(onPan))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func onPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        switch gesture.state {
        case .began:
            presenter.interactiveTransition = InteractiveTransition()
            wasToolbarHidden = isToolbarHidden
            setNavigationBarHidden(true, animated: true)
            setToolbarHidden(true, animated: true)
            dismiss(animated: true)
        case .changed:
            let percentComplete = translation.y / gesture.view!.bounds.height
            if percentComplete < 0 {
                if !presenter.reversedDismiss {
                    presenter.interactiveTransition?.cancel()
                    presenter.interactiveTransition = InteractiveTransition()
                    presenter.reversedDismiss.toggle()
                    dismiss(animated: true)
                }
            } else {
                if presenter.reversedDismiss {
                    presenter.interactiveTransition?.cancel()
                    presenter.interactiveTransition = InteractiveTransition()
                    presenter.reversedDismiss.toggle()
                    dismiss(animated: true)
                }
            }
            presenter.interactiveTransition?.update(abs(percentComplete))
        case .ended:
            if abs(translation.y) > 60 {
                presenter.interactiveTransition?.finish()
                presenter.interactiveTransition = nil
            } else {
                presenter.interactiveTransition?.cancel()
                presenter.interactiveTransition = nil
                setNavigationBarHidden(wasToolbarHidden, animated: true)
                setToolbarHidden(wasToolbarHidden, animated: true)
            }
        case .cancelled, .failed:
            presenter.interactiveTransition?.cancel()
            presenter.interactiveTransition = nil
            setNavigationBarHidden(wasToolbarHidden, animated: true)
            setToolbarHidden(wasToolbarHidden, animated: true)
        default:
            break
        }
    }
}

extension PreviewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(
        _ gestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        let panGesture = gestureRecognizer as? UIPanGestureRecognizer
        guard let panGesture else { return false }
        let velocity = panGesture.velocity(in: panGesture.view)
        return abs(velocity.y) > abs(velocity.x)
    }
}


extension PreviewController: UIPageViewControllerDataSource {
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        let previewItemViewController = viewController as! PreviewItemViewController
        let beforeIndex = previewItemViewController.index - 1
        guard beforeIndex >= 0 else { return nil }
        let item = dataSource?.previewController(
            self,
            previewItemAt: beforeIndex
        )
        guard let item else { return nil }
        return PreviewItemViewController(item, index: beforeIndex)
    }
    
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let previewItemViewController = viewController as! PreviewItemViewController
        let afterIndex = previewItemViewController.index + 1
        let itemsCount = dataSource?.numberOfPreviewItems(in: self)
        guard let itemsCount else { return nil }
        guard afterIndex < itemsCount else { return nil }
        let item = dataSource?.previewController(
            self,
            previewItemAt: afterIndex
        )
        guard let item else { return nil }
        return PreviewItemViewController(item, index: afterIndex)
    }
}

extension PreviewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentViewController = pageViewController.viewControllers?.first as? PreviewItemViewController
        if let currentViewController {
            currentPreviewItemIndex = currentViewController.index
        }
    }
}

extension PreviewController: PageViewControllerUIDelegate {
    func dismissActionTriggered() {
        setNavigationBarHidden(true, animated: true)
        setToolbarHidden(true, animated: true)
        dismiss(animated: true)
    }
    
    func presentActivityActionTriggered() {
        let item = dataSource?.previewController(self, previewItemAt: currentPreviewItemIndex)
        let configuration = item?.makeActivityItemsConfiguration()
        guard let configuration else { return }
        let vc = UIActivityViewController(
            activityItemsConfiguration: configuration
        )
        present(vc, animated: true)
    }
}

fileprivate final class Toolbar: UIToolbar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 100
        return size
    }
}
