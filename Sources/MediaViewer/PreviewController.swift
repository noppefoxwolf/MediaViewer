import UIKit
import QuickLook

public final class PreviewController: WorkaroundNavigationController {
    
    private let presenter = Presenter()
    
    public weak var dataSource: PreviewControllerDataSource? = nil
    
    var wasToolbarHidden: Bool = false
    
    let pageViewController = PageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    
    public init() {
        super.init(nibName: nil, bundle: nil)
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
        
        let item = dataSource!.previewController(self, previewItemAt: 0)
        pageViewController.setViewControllers(
            [PreviewItemViewController(item.makeViewController())],
            direction: .forward,
            animated: false
        )
        pageViewController.dataSource = self
        
        let panGesture = UIPanGestureRecognizer()
        panGesture.delegate = self
        panGesture.addTarget(self, action: #selector(onPan))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func onPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        switch gesture.state {
        case .began:
            presenter.interactor = Interactor()
            wasToolbarHidden = isToolbarHidden
            setNavigationBarHidden(true, animated: true)
            setToolbarHidden(true, animated: true)
            dismiss(animated: true)
        case .changed:
            let percentComplete = translation.y / gesture.view!.bounds.height
            presenter.interactor?.update(percentComplete)
        case .ended:
            if abs(translation.y) > 60 {
                presenter.interactor?.finish()
                presenter.interactor = nil
            } else {
                presenter.interactor?.cancel()
                presenter.interactor = nil
                setNavigationBarHidden(wasToolbarHidden, animated: true)
                setToolbarHidden(wasToolbarHidden, animated: true)
            }
        case .cancelled, .failed:
            presenter.interactor?.cancel()
            presenter.interactor = nil
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
        let item = dataSource!.previewController(self, previewItemAt: 0)
        let vc = item.makeViewController()
        return PreviewItemViewController(vc)
    }
    
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let item = dataSource!.previewController(self, previewItemAt: 0)
        let vc = item.makeViewController()
        return PreviewItemViewController(vc)
    }
}

