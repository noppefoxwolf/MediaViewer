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
    
    override var keyCommands: [UIKeyCommand]? {
        [
            {
                let command = UIKeyCommand(
                    input: UIKeyCommand.inputLeftArrow,
                    modifierFlags: [],
                    action: #selector(backward)
                )
                command.wantsPriorityOverSystemBehavior = true
                return command
            }(),
            {
                let command = UIKeyCommand(
                    input: UIKeyCommand.inputRightArrow,
                    modifierFlags: [],
                    action: #selector(forward)
                )
                command.wantsPriorityOverSystemBehavior = true
                return command
            }()
        ]
    }
    
    @objc func backward() {
        guard let currentViewController = viewControllers?.first else {
            return
        }
        let beforeViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController)
        if let beforeViewController {
            setViewControllers(
                [beforeViewController],
                direction: .reverse,
                animated: true,
                completion: nil
            )
        }
    }
    
    @objc func forward() {
        guard let currentViewController = viewControllers?.first else {
            return
        }
        let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController)
        if let nextViewController {
            setViewControllers(
                [nextViewController],
                direction: .forward,
                animated: true,
                completion: nil
            )
        }
    }
}
