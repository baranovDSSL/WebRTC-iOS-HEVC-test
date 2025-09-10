// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "WebRTCLib",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "WebRTC",
            targets: ["WebRTC"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/baranovDSSL/WebRTC-iOS-HEVC-test/releases/download/v1.0.5/WebRTC.xcframework.zip",
            checksum: "eb7807ee8e1c6f184827a94ac02f0c2d22896ad9dd03e352e4570c51f46ec081"
        )
    ]
)
