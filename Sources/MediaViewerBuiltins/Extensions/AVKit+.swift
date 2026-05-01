import AVKit

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
            let (cgImage, _) = try await generator.image(at: middleTime)
            return UIImage(cgImage: cgImage)
        } catch {
            return nil
        }
    }
}
