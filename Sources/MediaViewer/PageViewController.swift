import UIKit

final class PageViewController: UIPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            primaryAction: UIAction { [weak self] _ in
                self?.navigationController?.setNavigationBarHidden(true, animated: true)
                self?.navigationController?.setToolbarHidden(true, animated: true)
                self?.dismiss(animated: true)
            }
        )
        navigationItem.leftBarButtonItem?.setBackgroundImage(.makeBarBackground(), for: .normal, barMetrics: .default)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"))
        navigationItem.rightBarButtonItem?.setBackgroundImage(.makeBarBackground(), for: .normal, barMetrics: .default)
        toolbarItems = [UIBarButtonItem(systemItem: .action)]
        
        
    }
}
