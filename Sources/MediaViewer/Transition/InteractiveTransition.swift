import UIKit

final class InteractiveTransition: UIPercentDrivenInteractiveTransition {
    override init() {
        super.init()
        completionCurve = .linear
    }
    
    override func update(_ percentComplete: CGFloat) {
        print(percentComplete)
    }
}
