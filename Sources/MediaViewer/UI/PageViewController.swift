import UIKit

@MainActor
protocol PageViewControllerUIDelegate: AnyObject {
    func dismissActionTriggered()
    func presentActivityActionTriggered()
}

final class PageViewController: UIPageViewController {
    weak var uiDelegate: (any PageViewControllerUIDelegate)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            primaryAction: UIAction { [weak self] _ in
                self?.uiDelegate?.dismissActionTriggered()
            }
        )
        
        if #unavailable(iOS 19) {
            navigationItem.leftBarButtonItem?.setBackgroundImage(.makeBarBackground(), for: .normal, barMetrics: .default)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            primaryAction: UIAction { [weak self] _ in
                self?.uiDelegate?.presentActivityActionTriggered()
            }
        )
        
        if #unavailable(iOS 19) {
            navigationItem.rightBarButtonItem?.setBackgroundImage(.makeBarBackground(), for: .normal, barMetrics: .default)
        }
    }
}
