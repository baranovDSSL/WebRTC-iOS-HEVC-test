Pod::Spec.new do |spec|
  spec.name         = "WebRTCLib"
  spec.version      = "1.0.8"
  spec.summary      = "WebRTC с поддержкой H.265"

  spec.homepage     = "https://github.com/baranovDSSL/WebRTC-iOS-HEVC-test"
  spec.license      = { :type => 'BSD', :file => 'LICENSE' }
  spec.author       = "DSSL"
  
  spec.source       = { 
    :git => "https://github.com/baranovDSSL/WebRTC-iOS-HEVC-test.git",
    :tag => "v#{spec.version}"
  }

  spec.ios.deployment_target = '13.0'
  spec.vendored_frameworks = "WebRTC.xcframework"
  
  spec.frameworks = [
    'AVFoundation',
    'CoreMedia',
    'CoreVideo',
    'Foundation',
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