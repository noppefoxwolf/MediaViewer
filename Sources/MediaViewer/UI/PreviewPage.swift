public import UIKit
import AVKit
import Combine

public final class PreviewPage: Sendable, Identifiable {
    public let id: UUID
    
    public typealias ViewControllerProvider = @MainActor @Sendable () async -> UIViewController
    public typealias ThumbnailViewControllerProviderProvider = @MainActor @Sendable () -> UIViewController?
    public typealias ActivityProvider = @MainActor @Sendable () -> (any UIActivityItemsConfigurationReading)?
    
    private let viewControllerProvider: ViewControllerProvider
    private let thumbnailViewControllerProvider: ThumbnailViewControllerProviderProvider?
    private let activityProvider: ActivityProvider?
    
    public init(
        id: UUID = UUID(),
        viewControllerProvider: @escaping ViewControllerProvider,
        thumbnailViewControllerProvider: ThumbnailViewControllerProviderProvider? = nil,
        activityProvider: ActivityProvider? = nil
    ) {
        self.id = id
        self.viewControllerProvider = viewControllerProvider
        self.thumbnailViewControllerProvider = thumbnailViewControllerProvider
        self.activityProvider = activityProvider
    }
    
    @MainActor
    public func makeViewController() async -> UIViewController {
        await viewControllerProvider()
    }
    
    @MainActor
    public func makeThumbnailViewController() -> UIViewController? {
        thumbnailViewControllerProvider?()
    }
    
    @MainActor
    public func makeActivityItemsConfiguration() -> (any UIActivityItemsConfigurationReading)? {
        activityProvider?()
    }
}
