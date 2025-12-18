import SwiftUI
import AVFoundation
import UIKit
import MediaViewer
import MediaViewerBuiltins

enum Item: Hashable {
    case image(UIImage, String)
    case video(URL, String)
    case text(String)
    case failed
    
    var mediaPage: PreviewPage {
        switch self {
        case .image(let image, _):
            return PreviewPage(image: image)
        case .video(let url, _):
            return PreviewPage(player: AVPlayer(url: url))
        case .text(let text):
            return PreviewPage(
                viewControllerProvider: {
                    try! await Task.sleep(for: .seconds(1))
                    return UIHostingController(rootView: Text(text).font(.title))
                },
                thumbnailViewControllerProvider: {
                    UIHostingController(rootView: ProgressView())
                }
            )
        case .failed:
            return PreviewPage(player: AVPlayer(url: URL(string: "https://example.com")!))
        }
    }
}

final class ViewController: UICollectionViewController {
    private lazy var dataSource = createDataSource()
    
    init() {
        super.init(collectionViewLayout: Self.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MediaViewer Demo"
        loadData()
    }
    
    private static func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, environment in
            let columns = environment.container.effectiveContentSize.width > 500 ? 3 : 2
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0 / CGFloat(columns)),
                heightDimension: .fractionalHeight(1.0)
            ))
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(120)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            return section
        }
    }
    
    private func createDataSource() -> UICollectionViewDiffableDataSource<Int, Item> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item> { cell, indexPath, item in
            cell.contentConfiguration = UIHostingConfiguration {
                switch item {
                case .image(let image, let title):
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 80)
                            .clipped()
                            .cornerRadius(8)
                        Text(title)
                            .font(.caption)
                            .lineLimit(1)
                    }
                case .video(_, let title):
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black)
                                .frame(height: 80)
                            Image(systemName: "play.circle.fill")
                                .foregroundColor(.white)
                                .font(.title)
                        }
                        Text(title)
                            .font(.caption)
                            .lineLimit(1)
                    }
                case .text(let text):
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.2))
                                .frame(height: 80)
                            Image(systemName: "doc.text")
                                .foregroundColor(.blue)
                                .font(.title)
                        }
                        Text(text)
                            .font(.caption)
                            .lineLimit(1)
                    }
                case .failed:
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.2))
                                .frame(height: 80)
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(.blue)
                                .font(.title)
                        }
                        Text("Failed")
                            .font(.caption)
                            .lineLimit(1)
                    }
                }
            }
        }
        
        return UICollectionViewDiffableDataSource<Int, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    private func loadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        snapshot.appendSections([0])
        
        let items: [Item] = [
            .image(UIImage(resource: .image1), "Photo 1"),
            .image(UIImage(resource: .image2), "Photo 2"),
            .video(URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/adv_dv_atmos/main.m3u8")!, "Sample Video"),
            .text("Hello, World!"),
            .failed
        ]
        
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let items = dataSource.snapshot().itemIdentifiers
        let mediaPages = items.map(\.mediaPage)
        
        let previewController = PreviewController()
        previewController.delegate = self
        previewController.previewPages = mediaPages
        previewController.currentPreviewItemIndex = indexPath.item
        
        present(previewController, animated: true)
    }
}

extension ViewController: PreviewControllerDelegate {
    func previewController(_ controller: PreviewController, transitionViewFor page: PreviewPage) -> UIView? {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return nil }
        return collectionView.cellForItem(at: indexPath)
    }
}
