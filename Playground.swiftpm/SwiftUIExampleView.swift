import MediaViewer
import SwiftUI
import UIKit

struct SwiftUIExampleView: View {
    @State private var selection: PreviewSelection?

    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 8)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(Array(ExampleItem.samples.enumerated()), id: \.element) { index, item in
                        Button {
                            selection = PreviewSelection(index: index)
                        } label: {
                            ExampleItemThumbnail(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .navigationTitle("SwiftUI Example")
        }
        .sheet(item: $selection) { selection in
            PreviewControllerView(
                previewPages: ExampleItem.samples.map(\.mediaPage),
                currentPreviewItemIndex: selection.index
            )
        }
    }
}

private struct PreviewSelection: Identifiable {
    let index: Int

    var id: Int { index }
}

private struct ExampleItemThumbnail: View {
    let item: ExampleItem

    var body: some View {
        VStack {
            preview
                .frame(height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(item.title)
                .font(.caption)
                .lineLimit(1)
        }
    }

    @ViewBuilder
    private var preview: some View {
        switch item {
        case .image(let image, _):
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        case .video:
            ZStack {
                Color.black
                Image(systemName: "play.circle.fill")
                    .foregroundColor(.white)
                    .font(.title)
            }
        case .text:
            ZStack {
                Color.blue.opacity(0.2)
                Image(systemName: "doc.text")
                    .foregroundColor(.blue)
                    .font(.title)
            }
        case .failed:
            ZStack {
                Color.blue.opacity(0.2)
                Image(systemName: "exclamationmark.circle")
                    .foregroundColor(.blue)
                    .font(.title)
            }
        }
    }
}

private struct PreviewControllerView: UIViewControllerRepresentable {
    let previewPages: [PreviewPage]
    let currentPreviewItemIndex: Int

    func makeUIViewController(context: Context) -> PreviewController {
        let previewController = PreviewController()
        previewController.previewPages = previewPages
        previewController.currentPreviewItemIndex = currentPreviewItemIndex
        return previewController
    }

    func updateUIViewController(_ previewController: PreviewController, context: Context) {
        previewController.previewPages = previewPages
        previewController.currentPreviewItemIndex = currentPreviewItemIndex
    }
}
