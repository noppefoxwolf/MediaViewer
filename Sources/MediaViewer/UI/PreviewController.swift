public import UIKit
import os

open class PreviewController: UIViewController {
    let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: #file
    )
    
    private let presenter = Presenter()
    
    public var previewPages: [PreviewPage] = [] {
        didSet {
            refreshCurrentPreviewItem()
        }
    }
    public weak var delegate: (any PreviewControllerDelegate)? = nil
    
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
    
    public var currentPreviewItem: PreviewPage? {
        guard currentPreviewItemIndex < previewPages.count else { return nil }
        return previewPages[currentPreviewItemIndex]
    }
    
    public func refreshCurrentPreviewItem() {
        guard currentPreviewItemIndex < previewPages.count else { return }
        let page = previewPages[currentPreviewItemIndex]
        let vc = PreviewItemViewController(
            page,
            index: currentPreviewItemIndex
        )
        pageViewController.setViewControllers(
            [vc],
            direction: .forward,
            animated: false
        )
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = presenter
        modalPresentationStyle = .custom
    }
    
    public required init?(coder: NSCoder) { fatalError() }
    
    open override func viewDidLoad() {
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
        
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.addTarget(self, action: #selector(onLongPress))
        view.addGestureRecognizer(longPressGesture)
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
                    presenter.reversedDismiss.toggle()
                }
            } else {
                if presenter.reversedDismiss {
                    presenter.reversedDismiss.toggle()
                }
            }
            presenter.interactiveTransition?.reversed = presenter.reversedDismiss
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
    
    @objc private func onLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        presentActivityActionTriggered()
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
        guard beforeIndex >= 0 && beforeIndex < previewPages.count else { return nil }
        let page = previewPages[beforeIndex]
        return PreviewItemViewController(page, index: beforeIndex)
    }
    
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let previewItemViewController = viewController as! PreviewItemViewController
        let afterIndex = previewItemViewController.index + 1
        guard afterIndex < previewPages.count else { return nil }
        let page = previewPages[afterIndex]
        return PreviewItemViewController(page, index: afterIndex)
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
        guard currentPreviewItemIndex < previewPages.count else { return }
        let page = previewPages[currentPreviewItemIndex]
        let configuration = page.makeActivityItemsConfiguration()
        guard let configuration else { return }
        let vc = UIActivityViewController(
            activityItemsConfiguration: configuration
        )
        vc.popoverPresentationController?.sourceItem = pageViewController.navigationItem.rightBarButtonItem
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
