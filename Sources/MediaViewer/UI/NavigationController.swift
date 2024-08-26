import UIKit

@MainActor
final class NavigationController: WorkaroundNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.backgroundColor = isDarkMode ? .black : .white
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        setBarHidden(false, animated: false)
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor.label
        ]
        navigationBar.standardAppearance = navigationBarAppearance
        navigationBar.scrollEdgeAppearance = navigationBarAppearance

        let toolbarAppearance = UIToolbarAppearance()
        toolbar.standardAppearance = toolbarAppearance
        
        edgesForExtendedLayout = [.top]
        
        hidesBarsOnTap = true
    }
    
    func setBarHidden(_ hidden: Bool, animated: Bool) {
        setNavigationBarHidden(hidden, animated: animated)
        setToolbarHidden(hidden, animated: animated)
    }
    
}
