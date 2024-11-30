// swift-tools-version: 6.0
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
        .library(
            name: "MediaViewerBuiltins",
            targets: ["MediaViewerBuiltins"]
        )
    ],
    dependencies: [
        /* No dependencies!! */
    ],
    targets: [
        .target(
            name: "MediaViewer"
        ),
        .target(
            name: "MediaViewerBuiltins",
            dependencies: [
                "MediaViewer"
            ]
        ),
        .testTarget(
            name: "MediaViewerTests",
            dependencies: ["MediaViewer"]
        ),
    ]
)
