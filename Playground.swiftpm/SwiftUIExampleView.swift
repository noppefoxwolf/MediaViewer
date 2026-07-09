import MediaViewer
import MediaViewerSwiftUI
import SwiftUI
import UIKit

struct SwiftUIExampleView: View {
    @State private var selectedItem: PreviewPage?

    private let previewPages = ExampleItem.samples.map(\.mediaPage)
    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 8)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(Array(ExampleItem.samples.enumerated()), id: \.element) { index, item in
                        Button {
                            selectedItem = previewPages[index]
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
        .mediaViewer(
            item: $selectedItem,
            items: previewPages
        )
    }
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
