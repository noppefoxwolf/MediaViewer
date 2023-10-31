import UIKit

final class NavigationController: WorkaroundNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarHidden(false, animated: false)
        
        navigationBar.standardAppearance.configureWithTransparentBackground()
        navigationBar.tintColor = .white
        
        toolbar.standardAppearance = UIToolbarAppearance()
        toolbar.standardAppearance.configureWithTransparentBackground()
        toolbar.tintColor = .white
        
        hidesBarsOnTap = true
    }
    
    func setBarHidden(_ hidden: Bool, animated: Bool) {
        setNavigationBarHidden(hidden, animated: animated)
        setToolbarHidden(hidden, animated: animated)
    }
}
