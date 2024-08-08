import UIKit

@MainActor
final class PreviewItemViewController: UIViewController, DismissTransitionViewProviding {
    
    let previewItem: any PreviewItem
    let index: Int
    var readyToPreviewTask: Task<Void, any Error>? = nil
    
    var viewForDismissTransitionStartFrame: UIView? {
        if let child = children.compactMap { $0 as? DismissTransitionViewProviding }.first {
            return child.viewForDismissTransition
        }
        return nil
    }

    var viewForDismissTransition: UIView? {
        if let child = children.compactMap { $0 as? DismissTransitionViewProviding }.first {
            return child.viewForDismissTransition
        }
        return nil
    }
    
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
