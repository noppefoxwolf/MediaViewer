import UIKit
import AVFoundation

protocol PageViewControllerUIDelegate: AnyObject {
    func dismissActionTriggered()
    func presentActivityActionTriggered()
}

final class PageViewController: UIPageViewController {
    
    weak var uiDelegate: PageViewControllerUIDelegate? = nil
    
    private weak var seekBar: Seekbar?
    
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
        view.backgroundColor = .clear
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .done, primaryAction: UIAction { [weak self] _ in
            self?.uiDelegate?.dismissActionTriggered()
        })
        view.addSubview(itemBottomStack)
        setupConstraints()
    }
    
    public func showSeekBar(for player: AVPlayer) {
        clearSeekBar()
        let bar = Seekbar(player)
        seekBar = bar
        itemBottomStack.addArrangedSubview(bar)
    }
    
    public func clearSeekBar() {
        if let seekBar {
            itemBottomStack.removeArrangedSubViewProperly(seekBar)
        }
        seekBar = nil
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            itemBottomStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemBottomStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemBottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

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
