import UIKit

public final class PreviewItemViewController: UIViewController {
    let contentViewController: UIViewController
    
    public init(_ contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        embed(contentViewController)
    }
}
