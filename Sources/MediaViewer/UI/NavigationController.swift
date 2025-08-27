import UIKit

final class NavigationController: WorkaroundNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarHidden(false, animated: false)
        
        navigationBar.standardAppearance.configureWithTransparentBackground()
        navigationBar.tintColor = .white
        
        let toolbarAppearance = UIToolbarAppearance()
        toolbarAppearance.configureWithTransparentBackground()
        toolbar.standardAppearance = toolbarAppearance
        toolbar.compactAppearance = toolbarAppearance
        toolbar.scrollEdgeAppearance = toolbarAppearance
        toolbar.compactScrollEdgeAppearance = toolbarAppearance
        toolbar.tintColor = .white
        
        hidesBarsOnTap = true
    }
    
    func setBarHidden(_ hidden: Bool, animated: Bool) {
        setNavigationBarHidden(hidden, animated: animated)
        setToolbarHidden(hidden, animated: animated)
    }
}
