import UIKit

@MainActor
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thumbnailImageView)
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: view.topAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}
