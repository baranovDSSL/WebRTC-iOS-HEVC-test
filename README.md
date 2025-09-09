# WebRTC with H.265/HEVC Support

## Installation

### CocoaPods
```ruby
pod 'WebRTC-H265'
```

### Local Build
```bash
git clone https://github.com/baranovDSSL/WebRTC-iOS-HEVC-test
cd WebRTC-iOS-HEVC-test
./build_all.sh
```

## H.265 Modifications
- RTCVideoEncoderH265 implementation
- VideoToolbox hardware acceleration
- 19 patches for WebRTC integration
- Based on WebRTC M139