Pod::Spec.new do |spec|
  spec.name         = 'WebRTC-lib'
  spec.version      = '1.0.0'
  spec.summary      = 'WebRTC с поддержкой H.265'

  spec.homepage     = 'https://github.com/baranovDSSL/WebRTC-iOS-HEVC-test'
  spec.license      = { :type => 'BSD', :file => 'LICENSE' }
  
  # For CocoaPods distribution - will point to GitHub release
  spec.source       = { 
    :http => "https://github.com/baranovDSSL/WebRTC-iOS-HEVC-test/releases/download/v#{spec.version}/WebRTC.xcframework.zip",
    :sha256 => "51060ed174e2f45c264e094eb559b2bd54663bd782676e484e6a93f28fa427ba"
  }

  spec.ios.deployment_target = '13.0'

  spec.vendored_frameworks = 'WebRTC.xcframework'
  
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
