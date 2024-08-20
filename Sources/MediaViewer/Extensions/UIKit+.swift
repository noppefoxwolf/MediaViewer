import UIKit

extension UIViewController {
    func embed(_ viewController: UIViewController) {
        viewController.extendedLayoutIncludesOpaqueBars = true
        viewController.edgesForExtendedLayout = [.top, .bottom]
        viewController.willMove(toParent: self)
        view.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(viewController)
        viewController.didMove(toParent: self)
        guard let vcView = viewController.view else {
            return
        }
        NSLayoutConstraint.activate([
            vcView.topAnchor.constraint(equalTo: view.topAnchor),
            vcView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vcView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vcView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    func digup() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
        didMove(toParent: nil)
    }
}

extension UIImage {
    static func makeBarBackground() -> UIImage {
        let size = CGSize(width: 32, height: 32)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let pathRect = CGRect(origin: .zero, size: size)
            let path = CGPath(ellipseIn: pathRect, transform: nil)
            context.cgContext.setFillColor(CGColor(gray: 0, alpha: 0.5))
            context.cgContext.addPath(path)
            context.cgContext.fillPath()
        }
    }
}
