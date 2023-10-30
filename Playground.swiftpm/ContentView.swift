import SwiftUI
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
                Text("ok")
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
        snapshot.appendItems((0..<10).map({ _ in Item() }), toSection: .items)
        
        dataSource.apply(snapshot)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PreviewController()
        vc.dataSource = self
        present(vc, animated: true)
    }
}

extension ViewController: PreviewControllerDataSource {
    func numberOfPreviewItems(in controller: PreviewController) -> Int {
        100
    }
    
    func previewController(_ controller: PreviewController, previewItemAt index: Int) -> any PreviewItem {
        "Hello"
    }
}

extension String: PreviewItem {
    public var previewItemID: String { self }
    public func makeViewController() -> some UIViewController {
        //ImagePreviewItemViewController()
        PlayerPreviewItemViewController()
    }
}

