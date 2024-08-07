import UIKit

final class NavigationController: WorkaroundNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
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
