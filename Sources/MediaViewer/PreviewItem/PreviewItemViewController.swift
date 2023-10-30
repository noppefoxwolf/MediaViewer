import UIKit

final class PreviewItemViewController: UIViewController {
    let contentViewController: UIViewController
    let index: Int
    
    init(_ previewItem: any PreviewItem, index: Int) {
        self.contentViewController = previewItem.makeViewController()
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embed(contentViewController)
    }
}
