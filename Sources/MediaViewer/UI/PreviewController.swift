import UIKit

public final class PreviewController: UIViewController {
    
    private let presenter = Presenter()
    
    public weak var dataSource: PreviewControllerDataSource? = nil
    public weak var delegate: PreviewControllerDelegate? = nil
    
    let internalNavigationController = NavigationController(
        navigationBarClass: UINavigationBar.self,
        toolbarClass: Toolbar.self
    )
    
    var wasToolbarHidden: Bool = false
    
    let pageViewController = PageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: [.interPageSpacing : UIStackView.spacingUseSystem]
    )
    
    public var currentPreviewItemIndex: Int = 0
    
    public var currentPreviewItem: (any PreviewItem)? {
        dataSource?.previewController(self, previewItemAt: currentPreviewItemIndex)
    }
    
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
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = presenter
        modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        embed(internalNavigationController)
        internalNavigationController.setViewControllers([pageViewController], animated: false)
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
            wasToolbarHidden = internalNavigationController.isToolbarHidden
            internalNavigationController.setBarHidden(true, animated: true)
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
                internalNavigationController.setBarHidden(wasToolbarHidden, animated: true)
            }
        case .cancelled, .failed:
            presenter.interactiveTransition?.cancel()
            presenter.interactiveTransition = nil
            internalNavigationController.setBarHidden(wasToolbarHidden, animated: true)
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
        internalNavigationController.setNavigationBarHidden(true, animated: true)
        internalNavigationController.setToolbarHidden(true, animated: true)
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

// MARK: utils
extension PreviewController {
    internal var currentTransitionView: UIView? {
        guard let currentPreviewItem else { return nil }
        return delegate?.previewController(self, transitionViewFor: currentPreviewItem)
    }
    
    internal var topView: UIView? {
        internalNavigationController
            .topViewController?
            .view
    }
}

fileprivate final class Toolbar: UIToolbar {
    // TODO: self-resizing height
    // TODO: transparency background when has any item
}
