import UIKit

final class PreviewItemViewController: UIViewController {
    let thumbnailImageView = UIImageView()
    let previewItem: any PreviewItem
    let index: Int
    var readyToPlayTask: Task<Void, any Error>? = nil
    
    init(_ previewItem: any PreviewItem, index: Int) {
        self.previewItem = previewItem
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        view = thumbnailImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thumbnailImageView.backgroundColor = .red
        thumbnailImageView.contentMode = .scaleAspectFit
        
        readyToPlayTask = Task {
            _ = try await previewItem.readyToPlay.first(where: { _ in true })
            view.backgroundColor = .blue
            embed(previewItem.makeViewController())
        }
    }
}
