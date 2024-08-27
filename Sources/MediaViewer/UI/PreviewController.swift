import UIKit
import AVFoundation

@MainActor
open class PreviewController: UIViewController {
    
    private(set) lazy var presenter: Presenter = {
        Presenter(onPresented: { [weak self] in
            guard let self else { return }
            delegate?.previewControllerDidPresent(self)
        }, onWillDismiss: { [weak self] in
            guard let self, let currentPreviewItem else { return }
            delegate?.previewController(self, willDismissWith: currentPreviewItem)
        }) { [weak self] in
            self?.delegate?.previewControllerDidDismiss()
        }
    }()
    
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
            let vc = createPreviewController(for: item, index: currentPreviewItemIndex)
            pageViewController.setViewControllers(
                [vc],
                direction: .forward,
                animated: false
            )
            pageViewController.navigationItem.title = item.title
            delegate?.previewController(self, didMoveTo: item)
        }
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = presenter
        modalPresentationStyle = .custom
    }
    
    public required init?(coder: NSCoder) { fatalError() }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscapeLeft, .landscapeRight]
    }
    
    open override var shouldAutorotate: Bool {
        return true
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setOrientation(to: .portrait)
    }
    
    private func setOrientation(to orientation: UIInterfaceOrientation) {
        guard let windowScene = view.window?.windowScene else { return }
        
        let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: orientation.mask)
        
        windowScene.requestGeometryUpdate(geometryPreferences) { error in
            print("Failed to update geometry: \(error.localizedDescription)")
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        embed(internalNavigationController)
        edgesForExtendedLayout = [.top, .bottom]
        extendedLayoutIncludesOpaqueBars = true
        pageViewController.edgesForExtendedLayout = [.top, .bottom]
        pageViewController.extendedLayoutIncludesOpaqueBars = true
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
    
    public func updateCurrentIndex(to newIndex: Int) {
        currentPreviewItemIndex = newIndex
        if let currentViewController = currentViewController as? PreviewItemViewController{
            currentViewController.index = newIndex
            // we set the view controllers array to the current one to clear
            // the side vc's and force asking the delegate on next swipe for next/prev vc's.
            pageViewController.setViewControllers([currentViewController],
                                                  direction: .forward,
                                                  animated: false)
        }
    }
    
    @objc private func onPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        switch gesture.state {
        case .began:
            presenter.interactiveTransition = InteractiveTransition()
            wasToolbarHidden = internalNavigationController.isToolbarHidden
            internalNavigationController.setBarHidden(false, animated: false)
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
            if abs(translation.y) > 90 {
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
    
    private func createPreviewController(for item: PreviewItem, index: Int) -> PreviewItemViewController {
        let vc = PreviewItemViewController(item, index: index)
        return vc
    }
}

@MainActor
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

@MainActor
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
        return createPreviewController(for: item, index: beforeIndex)
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
        return createPreviewController(for: item, index: afterIndex)
    }
}

@MainActor
extension PreviewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentViewController = pageViewController.viewControllers?.first as? PreviewItemViewController
        if let currentViewController {
            currentPreviewItemIndex = currentViewController.index
            pageViewController.navigationItem.title = currentPreviewItem?.title
            if let currentPreviewItem {
                delegate?.previewController(self, didMoveTo: currentPreviewItem)
            }
        }
    }
}

@MainActor
extension PreviewController: PageViewControllerUIDelegate {
    func dismissActionTriggered() {
        internalNavigationController.setNavigationBarHidden(false, animated: false)
        internalNavigationController.setToolbarHidden(false, animated: false)
        dismiss(animated: true)
    }
    
    @MainActor
    func presentActivityActionTriggered() async {
        guard let item = dataSource?.previewController(self, previewItemAt: currentPreviewItemIndex),
              let items = await dataSource?.activityItems(for: item) else {
            return
        }
        
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceItem = pageViewController.toolbarItems?.first
        present(activityController, animated: true)
    }
}

// MARK: utils
@MainActor
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
    
    // returns the current view controller viewed by the page vc
    internal var currentViewController: UIViewController? {
        pageViewController.viewControllers?.first
    }
}

fileprivate final class Toolbar: UIToolbar {
    // TODO: self-resizing height
    // TODO: transparency background when has any item
}

extension UIInterfaceOrientation {
    var mask: UIInterfaceOrientationMask {
        switch self {
        case .portrait:
            return .portrait
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .all
        }
    }
}

internal extension UIViewController {
    var isDarkMode: Bool {
        traitCollection.userInterfaceStyle == .dark
    }
}
