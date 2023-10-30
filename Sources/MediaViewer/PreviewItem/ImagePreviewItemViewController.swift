import UIKit

public final class ImagePreviewItemViewController: UIViewController, UIScrollViewDelegate {

    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var doubleTapGesture: UITapGestureRecognizer!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIScrollViewを作成
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        
        // NSLayoutConstraintを使用してUIScrollViewの制約を設定
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // UIImageViewを作成
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        scrollView.addSubview(imageView)
        
        // 画像をセット
        imageView.image = UIImage(named: "image")
        
        // ダブルタップジェスチャーレコグナイザーを作成し、UIImageViewに追加する
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTapGesture)
        
        // ズームスケールの設定
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = 1.0
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // UIScrollViewとUIImageViewのサイズを調整
        scrollView.frame = view.bounds
        updateZoomScale()
        
        // UIImageViewの制約を更新
        updateImageViewConstraints()
    }
    
    func updateZoomScale() {
        guard let image = imageView.image else { return }
        
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = image.size
        
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    func updateImageViewConstraints() {
        guard let image = imageView.image else { return }
        
        let widthScale = scrollView.bounds.size.width / image.size.width
        let heightScale = scrollView.bounds.size.height / image.size.height
        let minScale = min(widthScale, heightScale)
        
        let scaledImageWidth = image.size.width * minScale
        let scaledImageHeight = image.size.height * minScale
        
        imageView.frame = CGRect(
            x: (scrollView.bounds.size.width - scaledImageWidth) / 2,
            y: (scrollView.bounds.size.height - scaledImageHeight) / 2,
            width: scaledImageWidth,
            height: scaledImageHeight
        )
    }
    
    @objc func handleDoubleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            let tapPoint = gestureRecognizer.location(in: imageView)
            
            let newZoomScale = scrollView.maximumZoomScale
            let xSize = scrollView.bounds.size.width / newZoomScale
            let ySize = scrollView.bounds.size.height / newZoomScale
            let zoomRect = CGRect(x: tapPoint.x - xSize / 2, y: tapPoint.y - ySize / 2, width: xSize, height: ySize)
            
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
