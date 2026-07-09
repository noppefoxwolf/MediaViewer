import MediaViewer
import SwiftUI
import UIKit

public extension View {
    func mediaViewer(
        item: Binding<PreviewPage?>,
        items: [PreviewPage],
    ) -> some View {
        modifier(
            MediaViewerModifier(
                item: item,
                items: items,
            )
        )
    }
}

private struct MediaViewerModifier: ViewModifier {
    @Binding var item: PreviewPage?
    let items: [PreviewPage]

    func body(content: Content) -> some View {
        content.background {
            MediaViewerPresentationAnchor(
                item: $item,
                items: items,
            )
            .frame(width: 0, height: 0)
        }
    }
}

private struct MediaViewerPresentationAnchor: UIViewControllerRepresentable {
    @Binding var item: PreviewPage?
    let items: [PreviewPage]

    func makeUIViewController(context: Context) -> MediaViewerAnchorViewController {
        let viewController = MediaViewerAnchorViewController()
        viewController.onDismiss = {
            item = nil
        }
        return viewController
    }

    func updateUIViewController(
        _ viewController: MediaViewerAnchorViewController,
        context: Context
    ) {
        viewController.update(
            items: items,
            selectedItem: item
        )
    }
}

private final class MediaViewerAnchorViewController: UIViewController {
    var onDismiss: (() -> Void)?
    private weak var previewController: MediaViewerPresentationController?

    func update(
        items: [PreviewPage],
        selectedItem: PreviewPage?
    ) {
        guard isViewLoaded else { return }

        if let selectedItem {
            presentPreviewControllerIfNeeded(
                items: items,
                selectedItem: selectedItem
            )
        } else {
            dismissPreviewControllerIfNeeded()
        }
    }

    private func presentPreviewControllerIfNeeded(
        items: [PreviewPage],
        selectedItem: PreviewPage
    ) {
        let currentPreviewItemIndex = items.firstIndex(where: { $0 === selectedItem }) ?? 0

        if let previewController {
            previewController.previewPages = items
            previewController.currentPreviewItemIndex = currentPreviewItemIndex
            previewController.refreshCurrentPreviewItem()
            return
        }

        guard presentedViewController == nil else { return }

        let previewController = MediaViewerPresentationController()
        previewController.onDismiss = { [weak self] in
            self?.previewController = nil
            self?.onDismiss?()
        }
        previewController.previewPages = items
        previewController.currentPreviewItemIndex = currentPreviewItemIndex
        previewController.refreshCurrentPreviewItem()
        self.previewController = previewController

        present(previewController, animated: true)
    }

    private func dismissPreviewControllerIfNeeded() {
        guard let previewController else { return }
        previewController.dismiss(animated: true)
        self.previewController = nil
    }
}

private final class MediaViewerPresentationController: PreviewController {
    var onDismiss: (() -> Void)?

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isBeingDismissed || presentingViewController == nil {
            onDismiss?()
        }
    }
}
