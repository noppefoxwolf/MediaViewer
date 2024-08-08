import UIKit

@MainActor
final class InteractiveTransition: UIPercentDrivenInteractiveTransition {
    override init() {
        super.init()
        completionCurve = .linear
    }
    
}
