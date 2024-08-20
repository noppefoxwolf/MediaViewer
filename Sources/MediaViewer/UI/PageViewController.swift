import UIKit
import AVFoundation

@MainActor
protocol PageViewControllerUIDelegate: AnyObject {
    func dismissActionTriggered()
    func presentActivityActionTriggered() async
}

@MainActor
final class PageViewController: UIPageViewController {
    
    weak var uiDelegate: PageViewControllerUIDelegate? = nil
        
    private lazy var itemBottomStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .done, primaryAction: UIAction { [weak self] _ in
            self?.uiDelegate?.dismissActionTriggered()
        })
        toolbarItems = [UIBarButtonItem(systemItem: .action, primaryAction: UIAction { [weak self] _ in
            Task {
                await self?.uiDelegate?.presentActivityActionTriggered()
            }
        }), UIBarButtonItem.flexibleSpace()]
        view.addSubview(itemBottomStack)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            itemBottomStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemBottomStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemBottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

@MainActor
private extension UIStackView {
    @discardableResult
    func removeAllArrangedSubviews() -> [UIView] {
        return arrangedSubviews.reduce([UIView]()) { $0 + [removeArrangedSubViewProperly($1)] }
    }

    func removeArrangedSubViewProperly(_ view: UIView) -> UIView {
        removeArrangedSubview(view)
        NSLayoutConstraint.deactivate(view.constraints)
        view.removeFromSuperview()
        return view
    }
}
