import UIKit

protocol PageViewControllerUIDelegate: AnyObject {
    func dismissActionTriggered()
    func presentActivityActionTriggered()
}

final class PageViewController: UIPageViewController {
    weak var uiDelegate: PageViewControllerUIDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            primaryAction: UIAction { [weak self] _ in
                self?.uiDelegate?.dismissActionTriggered()
            }
        )
        navigationItem.leftBarButtonItem?.setBackgroundImage(.makeBarBackground(), for: .normal, barMetrics: .default)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            primaryAction: UIAction { [weak self] _ in
                self?.uiDelegate?.presentActivityActionTriggered()
            }
        )
        navigationItem.rightBarButtonItem?.setBackgroundImage(.makeBarBackground(), for: .normal, barMetrics: .default)
    }
}
