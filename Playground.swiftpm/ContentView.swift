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

enum Section: Int {
    case items
}

struct Item: Hashable {
    let id: UUID = UUID()
}

class ViewController: UITableViewController {
    lazy var dataSource = UITableViewDiffableDataSource<Section, Item>(
        tableView: tableView,
        cellProvider: { [unowned self] (tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.contentConfiguration = UIHostingConfiguration(content: {
                Text("open MediaViewer")
            })
            return cell
        }
    )
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        _ = dataSource
        
        snapshot.appendSections([.items])
        snapshot.appendItems((0..<1).map({ _ in Item() }), toSection: .items)
        
        dataSource.apply(snapshot)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PreviewController()
        vc.dataSource = self
        vc.currentPreviewItemIndex = 2
        present(vc, animated: true)
    }
    
    var items: [any PreviewItem] = [
        "a",
        "b",
        "c",
        "d",
        UIImage(named: "image")!,
        AVPlayer(url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/adv_dv_atmos/main.m3u8")!),
    ]
}

extension ViewController: PreviewControllerDataSource {
    func numberOfPreviewItems(in controller: PreviewController) -> Int {
        items.count
    }
    
    func previewController(_ controller: PreviewController, previewItemAt index: Int) -> any PreviewItem {
        items[index]
    }
}

extension String: PreviewItem {
    public func makeViewController() -> some UIViewController {
        //ImagePreviewItemViewController()
        //PlayerPreviewItemViewController()
        UIHostingController(rootView: Text(self))
    }
}

