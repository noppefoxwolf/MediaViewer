public import UIKit

public final class ThumbnailViewController: UIViewController {
    let thumbnailImageView = UIImageView()
    
    public init(unfolding: @escaping () async -> UIImage?) {
        super.init(nibName: nil, bundle: nil)
        Task {
            thumbnailImageView.image = await unfolding()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = thumbnailImageView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        thumbnailImageView.contentMode = .scaleAspectFit
    }
}
