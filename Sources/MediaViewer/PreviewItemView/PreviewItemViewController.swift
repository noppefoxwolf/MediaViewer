import UIKit

final class PreviewItemViewController: UIViewController {
    let previewPage: PreviewPage
    let index: Int
    var readyToPreviewTask: Task<Void, any Error>? = nil
    
    init(_ previewPage: PreviewPage, index: Int) {
        self.previewPage = previewPage
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        
        let thumbnailVC = previewPage.makeThumbnailViewController()
        if let thumbnailVC {
            embed(thumbnailVC)
        }
        
        readyToPreviewTask = Task {
            let contentVC = await previewPage.makeViewController()
            thumbnailVC?.digup()
            embed(contentVC)
        }
    }
}
