# WebRTC with H.265/HEVC Support

## Installation

### Swift Package Manager (Recommended)

#### Using Xcode
1. File → Add Package Dependencies
2. Enter repository URL: `https://github.com/baranovDSSL/WebRTC-iOS-HEVC-test`
3. Select version (1.0.0 or later)
4. Add to your target

#### Using Package.swift
```swift
dependencies: [
    .package(url: "https://github.com/baranovDSSL/WebRTC-iOS-HEVC-test", from: "1.0.0")
]
```

### CocoaPods
```ruby
pod 'WebRTC-lib'
```

### Local Build
```bash
git clone https://github.com/baranovDSSL/WebRTC-iOS-HEVC-test
cd WebRTC-iOS-HEVC-test
./build_all.sh
```

## Modifications
- H.265/HEVC codec support for iOS
- VideoToolbox hardware acceleration
- 19 patches for WebRTC integration
- Based on WebRTC M139

## Versions

| Version | WebRTC Base | Release Date | Features |
|---------|-------------|--------------|----------|
| 1.0.0   | M139        | 2025-09-10   | Initial H.265/HEVC support |

### Version Selection

When using Swift Package Manager, you can specify exact versions, version ranges, or use the latest:

```swift
// Exact version
.package(url: "https://github.com/baranovDSSL/WebRTC-iOS-HEVC-test", .exact("1.0.0"))

// From version (recommended)
.package(url: "https://github.com/baranovDSSL/WebRTC-iOS-HEVC-test", from: "1.0.0")

// Version range
.package(url: "https://github.com/baranovDSSL/WebRTC-iOS-HEVC-test", "1.0.0"..<"2.0.0")

// Branch (for development)
.package(url: "https://github.com/baranovDSSL/WebRTC-iOS-HEVC-test", .branch("main"))
```
