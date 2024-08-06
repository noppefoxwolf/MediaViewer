import UIKit

final class NavigationController: WorkaroundNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarHidden(false, animated: false)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor.label
        ]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = false

        toolbar.standardAppearance = UIToolbarAppearance()
        toolbar.standardAppearance.configureWithTransparentBackground()
        toolbar.tintColor = .white
        
        edgesForExtendedLayout = [.top]
        
        hidesBarsOnTap = true
    }
    
    func setBarHidden(_ hidden: Bool, animated: Bool) {
        setNavigationBarHidden(hidden, animated: animated)
        setToolbarHidden(hidden, animated: animated)
    }
    
}
