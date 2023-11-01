import UIKit

final class PreviewItemViewController: UIViewController {
    let previewItem: any PreviewItem
    let index: Int
    var readyToPreviewTask: Task<Void, any Error>? = nil
    
    init(_ previewItem: any PreviewItem, index: Int) {
        self.previewItem = previewItem
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        
        let thumbnailVC = previewItem.makeThumbnailViewController()
        if let thumbnailVC {
            embed(thumbnailVC)
        }
        
        readyToPreviewTask = Task {
            let contentVC = await previewItem.makeViewController()
            thumbnailVC?.digup()
            embed(contentVC)
        }
    }
}
