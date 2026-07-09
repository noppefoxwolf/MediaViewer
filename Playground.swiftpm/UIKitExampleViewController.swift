import SwiftUI
import UIKit
import MediaViewer

final class UIKitExampleViewController: UICollectionViewController {
    private lazy var dataSource = createDataSource()
    
    init() {
        super.init(collectionViewLayout: Self.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIKit Example"
        loadData()
    }
    
    private static func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, environment in
            let horizontalInsets: CGFloat = 32
            let interItemSpacing: CGFloat = 8
            let minimumItemWidth: CGFloat = 150
            let availableWidth = environment.container.effectiveContentSize.width - horizontalInsets
            let columns = max(
                Int((availableWidth + interItemSpacing) / (minimumItemWidth + interItemSpacing)),
                1
            )
            let itemWidth = (availableWidth - interItemSpacing * CGFloat(columns - 1)) / CGFloat(columns)
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(itemWidth),
                heightDimension: .fractionalHeight(1.0)
            ))
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(104)
                ),
                repeatingSubitem: item,
                count: columns
            )
            group.interItemSpacing = .fixed(interItemSpacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = interItemSpacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            return section
        }
    }
    
    private func createDataSource() -> UICollectionViewDiffableDataSource<Int, ExampleItem> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, ExampleItem> { cell, indexPath, item in
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
            }.margins(.all, 0)
        }
        
        return UICollectionViewDiffableDataSource<Int, ExampleItem>(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    private func loadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ExampleItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(ExampleItem.samples)
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

extension UIKitExampleViewController: PreviewControllerDelegate {
    func previewController(_ controller: PreviewController, transitionViewFor page: PreviewPage) -> UIView? {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return nil }
        return collectionView.cellForItem(at: indexPath)
    }
}
