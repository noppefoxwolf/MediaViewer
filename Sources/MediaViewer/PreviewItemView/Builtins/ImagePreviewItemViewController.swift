import UIKit

public final class ImagePreviewItemViewController: UIViewController, UIScrollViewDelegate {

    let scrollView = UIScrollView()
    let imageView = UIImageView()
    let doubleTapGesture = UITapGestureRecognizer()
    let image: UIImage
    
    private var viewAppeared = false
    
    public init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public override func loadView() {
        view = scrollView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Pin the scrollView to the view
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            // Pin the imageView to the scrollView's content edges
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor)
          ])
        
        imageView.image = image
        
        doubleTapGesture.addTarget(self, action: #selector(handleDoubleTapGesture))
        doubleTapGesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTapGesture)
        
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateZoomScaleForSize(view.bounds.size)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateZoomScaleForSize(view.bounds.size)
        viewAppeared = true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewAppeared == true {
            scrollView.zoomScale = scrollView.minimumZoomScale
        }
    }
    
    private func updateZoomScaleForSize(_ size: CGSize) {
        
        guard viewAppeared == false else {
            return
        }
        
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        
        scrollView.zoomScale = minScale
        scrollView.maximumZoomScale = minScale * 4
    }
    
    @objc private func handleDoubleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            let tapPoint = gestureRecognizer.location(in: imageView)
            
            let newZoomScale = scrollView.maximumZoomScale
            let xSize = scrollView.bounds.size.width / newZoomScale
            let ySize = scrollView.bounds.size.height / newZoomScale
            let zoomRect = CGRect(
                x: tapPoint.x - xSize / 2,
                y: tapPoint.y - ySize / 2,
                width: xSize,
                height: ySize
            )
            
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
      /// The amount to inset the scroll content from the top to keep it centered in the view.
      let inset: CGFloat = (scrollView.bounds.height - imageView.bounds.height * scrollView.zoomScale) / 2
      /// The amount to subtract from the top inset value to keep the content visually centered.
      let visualCenteringOffset = scrollView.bounds.height * 0.02
      // Set the top content inset relative to the current zoom level
      scrollView.contentInset.top = max(inset , 0)
    }
}
