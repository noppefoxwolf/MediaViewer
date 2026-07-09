import SwiftUI
import UIKit

struct UIKitExampleView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIKitExampleViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
