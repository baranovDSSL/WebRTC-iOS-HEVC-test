Pod::Spec.new do |spec|
  spec.name         = 'WebRTC-H265'
  spec.version      = '1.0.0'
  spec.summary      = 'WebRTC с поддержкой H.265'

  spec.description  = <<-DESC
    Custom WebRTC с поддержкой H.265 built from WebRTC M139.
    This version includes H.265 encoder and decoder with VideoToolbox integration for optimal
    performance on iOS devices.
    
    Key features:
    - H.265/HEVC hardware-accelerated encoding and decoding via VideoToolbox
    - H.264 support (standard WebRTC)
    - VP8/VP9 codec support
    - iOS 13.0+ compatibility
    - arm64 device and simulator support
    - Size optimized build (~250MB)
    
    Built from WebRTC commit: 23d8e44f84822170bee4425760b44237959423e5 (M139)
    Includes 19 H.265 patches for full HEVC integration.
  DESC

  spec.homepage     = 'https://github.com/baranovDSSL/WebRTC-iOS-HEVC-test'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'baranovDSSL' => 'baranov@dssl.com' }
  
  # For CocoaPods distribution - will point to GitHub release
  spec.source       = { 
    :http => "https://github.com/baranovDSSL/WebRTC-iOS-HEVC-test/releases/download/v#{spec.version}/WebRTC-H265.zip",
    :sha256 => "a3751924f276936c8a7569f3c8d95d9d272e44e80652d3537ed8717494c25b4f"
  }

  spec.ios.deployment_target = '13.0'
  spec.requires_arc = true

  spec.vendored_frameworks = 'WebRTC.xcframework'
  
  spec.frameworks = [
    'AVFoundation',
    'AudioToolbox', 
    'CoreAudio',
    'CoreMedia',
    'CoreVideo',
    'Foundation',
    'Metal',
    'MetalKit',
    'QuartzCore',
    'UIKit',
    'VideoToolbox'
  ]
  
  spec.libraries = [
    'c++'
  ]
  
  spec.pod_target_xcconfig = {
    'ENABLE_BITCODE' => 'NO',
    'OTHER_LDFLAGS' => '-ObjC',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
    'CLANG_CXX_LIBRARY' => 'libc++'
  }
  
  spec.user_target_xcconfig = {
    'ENABLE_BITCODE' => 'NO'
  }
end
