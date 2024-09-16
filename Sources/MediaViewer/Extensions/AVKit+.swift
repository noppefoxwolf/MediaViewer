@preconcurrency import AVKit

extension AVAsset {
    func makeThumbnailImage() async -> UIImage? {
        do {
            let duration = try await self.load(.duration)
            let middleTimeSeconds = duration.seconds / 2
            let middleTime = CMTimeMakeWithSeconds(
                middleTimeSeconds,
                preferredTimescale: duration.timescale
            )
            let generator = AVAssetImageGenerator(asset: self)
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
