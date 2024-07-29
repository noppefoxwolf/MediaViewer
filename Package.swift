// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MediaViewer",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "MediaViewer",
            targets: ["MediaViewer"]
        ),
    ],
    dependencies: [
        /* No dependencies!! */
    ],
    targets: [
        .target(
            name: "MediaViewer"
        ),
        .testTarget(
            name: "MediaViewerTests",
            dependencies: ["MediaViewer"]
        ),
    ]
)

// Only development

let warnConcurrency = "-warn-concurrency"
let enableActorDataRaceChecks = "-enable-actor-data-race-checks"
let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ForwardTrailingClosures"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("BareSlashRegexLiterals"),
    .enableUpcomingFeature("ConciseMagicFile"),
    .enableUpcomingFeature("ImportObjcForwardDeclarations"),
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableUpcomingFeature("DeprecateApplicationMain"),
    .enableUpcomingFeature("IsolatedDefaultValues"),
    .enableUpcomingFeature("GlobalConcurrency"),
    .unsafeFlags([
        warnConcurrency,
        enableActorDataRaceChecks,
    ]),
]

package.targets.forEach { target in
    target.swiftSettings = target.swiftSettings ?? []
    target.swiftSettings?.append(contentsOf: swiftSettings)
}

