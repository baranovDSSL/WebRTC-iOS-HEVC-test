// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "WebRTCLib",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "WebRTCLib",
            targets: ["WebRTCLib"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "WebRTCLib",
                    url: "https://github.com/baranovDSSL/WebRTC-iOS-HEVC-test/releases/download/v1.0.6/WebRTCLib.xcframework.zip",
            checksum: "fc98568b6cbca422ff9b25416e0c48e932b45034579897dc813488ffbb944ab4"
        )
    ]
)
