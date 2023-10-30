import UIKit

final class Interactor: UIPercentDrivenInteractiveTransition {
    override init() {
        super.init()
        completionCurve = .linear
    }
}
