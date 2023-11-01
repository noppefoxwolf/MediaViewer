import AVKit
import UIKit

extension AVPlayer: PreviewItem {
    public func makeViewController() -> UIViewController {
        PlayerPreviewItemViewController(player: self)
    }
    
    public func makeThumbnailImage() async -> UIImage? {
        do {
            guard let asset = currentItem?.asset else {
                return nil
            }
            let duration = try await asset.load(.duration)
            let middleTimeSeconds = duration.seconds / 2
            let middleTime = CMTimeMakeWithSeconds(
                middleTimeSeconds,
                preferredTimescale: duration.timescale
            )
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            let cgImage = try await withTaskCancellationHandler {
                try await withCheckedThrowingContinuation { (continuation) in
                    generator.generateCGImageAsynchronously(
                        for: middleTime,
                        completionHandler: { (cgImage, _, error) in
                            if let cgImage {
                                continuation.resume(with: .success(cgImage))
                            } else if let error {
                                continuation.resume(with: .failure(error))
                            }
                        }
                    )
                }
            } onCancel: {
                generator.cancelAllCGImageGeneration()
            }
            return UIImage(cgImage: cgImage)
        } catch {
            return nil
        }
    }
    
    public var readyToPreview: some AsyncSequence {
        publisher(for: \.status)
            .filter({ $0 == .readyToPlay })
            .delay(for: 5, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
            .values
    }
}
