#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DEPOT_TOOLS_DIR="$PROJECT_ROOT/depot_tools"
SRC_DIR="$PROJECT_ROOT/src"
WEBRTC_SRC="$SRC_DIR/src"

if [ -f "$PROJECT_ROOT/build_config.sh" ]; then
    source "$PROJECT_ROOT/build_config.sh"
fi

export PATH="$DEPOT_TOOLS_DIR:$PATH"

if [ ! -d "$WEBRTC_SRC" ]; then
    echo "[iOS Build] Error: WebRTC source not found. Please run fetch_webrtc.sh first"
    exit 1
fi

cd "$WEBRTC_SRC"

generate_ios_gn_args() {
    local target_cpu=$1
    local is_simulator=$2
    
    local args="target_os=\"ios\""
    args="$args target_cpu=\"$target_cpu\""
    args="$args is_debug=false"
    args="$args is_component_build=false"
    args="$args rtc_build_examples=false"
    args="$args rtc_include_tests=false"
    args="$args rtc_enable_protobuf=false"
    args="$args rtc_include_pulse_audio=false"
    args="$args rtc_use_gtk=false"
    args="$args treat_warnings_as_errors=false"
    args="$args use_custom_libcxx=false"
    args="$args use_rtti=true"
    
    args="$args ios_deployment_target=\"13.0\""
    args="$args enable_ios_bitcode=false"
    args="$args ios_enable_code_signing=false"
    args="$args use_xcode_clang=true"
    
    if [ "$is_simulator" = "true" ]; then
        args="$args target_environment=\"simulator\""
    else
        args="$args target_environment=\"device\""
    fi
    
    if [ "$ENABLE_LTO" = "true" ]; then
        args="$args use_lto=true"
        if [ "$ENABLE_THIN_LTO" = "true" ]; then
            args="$args use_thin_lto=true"
        fi
    fi
    
    if [ "$OPTIMIZE_FOR_SIZE" = "true" ]; then
        args="$args optimize_for_size=true"
    fi
    
    args="$args symbol_level=$SYMBOL_LEVEL"
    if [ "$STRIP_SYMBOLS" = "true" ]; then
        args="$args enable_stripping=true"
        args="$args remove_webcore_debug_symbols=true"
    else
        args="$args enable_stripping=false"
        args="$args remove_webcore_debug_symbols=false"
    fi
    
    args="$args enable_dead_code_stripping=false"
    args="$args rtc_enable_legacy_api_video_quality_observer=false"
    args="$args rtc_use_legacy_modules_directory=false"
    args="$args rtc_disable_trace_events=true"
    args="$args rtc_exclude_transient_suppressor=true"
    
    if [ "$ENABLE_METRICS" = "true" ]; then
        args="$args rtc_disable_metrics=false"
    else
        args="$args rtc_disable_metrics=true"
    fi
    
    args="$args rtc_enable_bwe_test_logging=false"
    args="$args rtc_include_dav1d_in_internal_decoder_factory=false"
    args="$args rtc_use_h265=true"
    args="$args rtc_enable_protobuf=false"
    args="$args rtc_builtin_task_queue_impl=false"
    args="$args use_clang_lld=true"
    args="$args clang_use_chrome_plugins=false"
    
    if [ "$ENABLE_H265" = "true" ]; then
        args="$args rtc_use_h265=true"
        args="$args ffmpeg_branding=\"Chrome\""
        args="$args proprietary_codecs=true"
    fi
    
    if [ "$ENABLE_VP9" = "true" ]; then
        args="$args rtc_libvpx_build_vp9=true"
    else
        args="$args rtc_libvpx_build_vp9=false"
    fi
    
    if [ "$ENABLE_AV1" = "true" ]; then
        args="$args rtc_use_libaom_av1_decoder=true"
        args="$args rtc_use_libaom_av1_encoder=true"
    fi
    
    args="$args rtc_include_opus=$ENABLE_OPUS"
    args="$args rtc_include_ilbc=$ENABLE_ILBC"
    args="$args rtc_include_isac=$ENABLE_ISAC"
    args="$args rtc_include_builtin_audio_codecs=true"
    args="$args rtc_enable_sctp=$ENABLE_SCTP"
    args="$args rtc_enable_external_auth=$ENABLE_EXTERNAL_AUTH"
    
    if [ "$STRIP_SYMBOLS" = "true" ]; then
        args="$args strip_debug_info=true"
    else
        args="$args strip_debug_info=false"
    fi
    
    args="$args rtc_use_videotoolbox=true"
    args="$args enable_modules=true"
    args="$args rtc_enable_objc_symbol_export=true"
    
    echo "$args"
}

build_ios_webrtc() {
    local arch=$1
    local is_simulator=$2
    local out_name=$3
    
    echo "[iOS Build] Building WebRTC for iOS ($arch)${is_simulator:+ (Simulator)}..."
    
    local out_dir="out/$out_name"
    local gn_args=$(generate_ios_gn_args "$arch" "$is_simulator")
    
    gn gen "$out_dir" --args="$gn_args"
    ninja -C "$out_dir"
    
    if [ $? -eq 0 ]; then
        echo "[iOS Build] ✅ Build completed successfully for iOS ($arch)${is_simulator:+ (Simulator)}"
    else
        echo "[iOS Build] ❌ Build failed for iOS ($arch)${is_simulator:+ (Simulator)}"
        exit 1
    fi
}

echo "[iOS Build] 🚀 Starting iOS WebRTC builds..."
echo "[iOS Build] 📱 Target: iOS 13.0+ (ARM64)"
echo "[iOS Build] 🎥 H.265/HEVC: Enabled with VideoToolbox hardware acceleration"
echo "[iOS Build] 🔧 Optimizations: Size optimization, LTO, symbol stripping enabled"

if [ "$BUILD_IOS" = "true" ]; then
    build_ios_webrtc "arm64" "false" "ios_arm64"
fi

if [ "$BUILD_IOS_SIM" = "true" ]; then
    build_ios_webrtc "arm64" "true" "ios_sim_arm64"
fi

echo "[iOS Build] 🎉 All iOS builds completed successfully!"
echo "[iOS Build] 📦 Ready for framework packaging..."