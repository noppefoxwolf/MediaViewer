import UIKit

extension UIViewController {
    func embed(_ viewController: UIViewController) {
        viewController.willMove(toParent: self)
        view.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(viewController)
        viewController.didMove(toParent: self)
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            viewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            view.rightAnchor.constraint(equalTo: viewController.view.rightAnchor),
        ])
    }
}

extension UIImage {
    static func makeBarBackground() -> UIImage {
        let size = CGSize(width: 32, height: 32)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let pathRect = CGRect(origin: .zero, size: size)
            let path = CGPath(ellipseIn: pathRect, transform: nil)
            context.cgContext.setFillColor(CGColor(gray: 0, alpha: 1))
            context.cgContext.addPath(path)
            context.cgContext.fillPath()
        }
    }
}
