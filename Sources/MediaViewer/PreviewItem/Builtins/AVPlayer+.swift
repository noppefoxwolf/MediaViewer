import AVKit
import UIKit

extension AVPlayer: PreviewItem {
    public func makeViewController() async -> UIViewController {
        _ = await publisher(for: \.status)
            .filter({ $0 == .readyToPlay })
            .eraseToAnyPublisher()
            .values
            .first(where: { _ in true })
        return PlayerPreviewItemViewController(player: self)
    }
    
    public func makeThumbnailViewController() -> UIViewController? {
        ThumbnailViewController { [weak self] in
            do {
                guard let asset = self?.currentItem?.asset else {
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
    }
}
