import SwiftUI
import AVFoundation
import UIKit
import MediaViewer

struct ContentView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        ViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

import UIKit

enum Section: Int {
    case items
}

enum Item: Hashable {
    case image(UIImage)
    case player(AVPlayer)
    case text(String)
}

extension Item {
    func makePreviewItem() -> any PreviewItem {
        switch self {
        case .image(let image):
            return image
        case .player(let player):
            return player
        case .text(let text):
            return text
        }
    }
}

class ViewController: UICollectionViewController {
    let cellRegistration = UICollectionView.CellRegistration(
        handler: { (cell: UICollectionViewCell, indexPath, item: Item) in
            cell.contentConfiguration = UIHostingConfiguration(content: {
                switch item {
                case .image(let image):
                    Color.clear
                        .overlay {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                        }
                        .clipped()
                case .player(let aVPlayer):
                    Color.black
                case .text(let text):
                    Text(text)
                }
            })
        }
    )
    
    lazy var dataSource = UICollectionViewDiffableDataSource<Section, Item>(
        collectionView: collectionView,
        cellProvider: { [unowned self] (collectionView, indexPath, item) in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    )
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 200, height: 200)
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = dataSource
        
        snapshot.appendSections([.items])
        snapshot.appendItems([
            Item.image(UIImage(named: "image1")!),
            Item.image(UIImage(named: "image2")!),
            Item.image(UIImage(named: "image3")!),
            Item.image(UIImage(named: "image4")!),
            Item.player({
                let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/adv_dv_atmos/main.m3u8")!
                let player = AVPlayer(url: url)
                player.automaticallyWaitsToMinimizeStalling = true
                return player
            }()),
            Item.text("Hello, World!")
        ], toSection: .items)
        
        dataSource.apply(snapshot)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PreviewController()
        vc.delegate = self
        vc.dataSource = self
        vc.currentPreviewItemIndex = indexPath.row
        present(vc, animated: true)
    }
}

extension ViewController: PreviewControllerDataSource {
    func numberOfPreviewItems(in controller: PreviewController) -> Int {
        dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
    }
    
    func previewController(_ controller: PreviewController, previewItemAt index: Int) -> any PreviewItem {
        let item = dataSource.itemIdentifier(for: IndexPath(row: index, section: 0))!
        return item.makePreviewItem()
    }
}

extension ViewController: PreviewControllerDelegate {
    func previewController(
        _ controller: PreviewController,
        transitionViewFor item: any PreviewItem
    ) -> UIView? {
        let indexPath = collectionView.indexPathsForSelectedItems!.first!
        return collectionView.cellForItem(at: indexPath)
    }
}

