import UIKit

@MainActor
public final class ImagePreviewItemViewController: UIViewController, UIScrollViewDelegate {

    let scrollView = UIScrollView()
    let imageView: UIImageView
    let doubleTapGesture = UITapGestureRecognizer()
    
    private var viewAppeared = false
    
    public init(image: UIImage) {
        imageView = UIImageView(image: image)
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(imageView: UIImageView) {
        self.imageView = imageView
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
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor)
          ])
        
        doubleTapGesture.addTarget(self, action: #selector(handleDoubleTapGesture))
        doubleTapGesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTapGesture)
        updateZoomScaleForSize(view.bounds.size)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateZoomScaleForSize(view.bounds.size)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateZoomScaleForSize(view.bounds.size)
        updateScrollInsets()
        viewAppeared = true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewAppeared == true {
            scrollView.zoomScale = scrollView.minimumZoomScale
        }
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.updateZoomScaleForSize(size, force: true)
            self.updateScrollInsets()
            }, completion: { context in
                self.updateZoomScaleForSize(size, force: true)
                self.updateScrollInsets()
            })
        
    }
    
    private func updateZoomScaleForSize(_ size: CGSize, force: Bool = false) {
        
        guard viewAppeared == false || force else {
            return
        }
        
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = minScale * 4
        scrollView.zoomScale = minScale
        
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
        updateScrollInsets()
    }
    
    private func updateScrollInsets() {
        let verticalInset = max((scrollView.bounds.height - imageView.bounds.height * scrollView.zoomScale) / 2, 0)
        let horizontalInset = max((scrollView.bounds.width - imageView.bounds.width * scrollView.zoomScale) / 2, 0)
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }

}

extension ImagePreviewItemViewController: DismissTransitionViewProviding {
    public var viewForDismissTransition: UIView? {
        imageView
    }
}
