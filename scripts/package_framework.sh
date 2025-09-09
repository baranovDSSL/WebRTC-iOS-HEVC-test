#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SRC_DIR="$PROJECT_ROOT/src"
WEBRTC_SRC="$SRC_DIR/src"
OUTPUT_DIR="$PROJECT_ROOT/output"

if [ -f "$PROJECT_ROOT/build_config.sh" ]; then
    source "$PROJECT_ROOT/build_config.sh"
fi

BUILD_IOS="${BUILD_IOS:-true}"
BUILD_IOS_SIM="${BUILD_IOS_SIM:-true}"
ARCHIVE_BUILDS="${ARCHIVE_BUILDS:-true}"

echo "[Package] 🔍 Checking for iOS build outputs..."

if [ ! -d "$WEBRTC_SRC/out/ios_arm64" ] && [ ! -d "$WEBRTC_SRC/out/ios_sim_arm64" ]; then
    echo "[Package] ❌ Error: No iOS builds found. Please run build_ios.sh first"
    exit 1
fi

echo "[Package] ✅ iOS build outputs found"

cd "$WEBRTC_SRC"

# Create output directory
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# Create temporary directories for each platform
DEVICE_TEMP_DIR="$OUTPUT_DIR/temp_device"
SIMULATOR_TEMP_DIR="$OUTPUT_DIR/temp_simulator"

if [ "$BUILD_IOS" = "true" ] && [ -d "$WEBRTC_SRC/out/ios_arm64/WebRTC.framework" ]; then
    echo "Copying iOS device framework..."
    mkdir -p "$DEVICE_TEMP_DIR"
    cp -R "$WEBRTC_SRC/out/ios_arm64/WebRTC.framework" "$DEVICE_TEMP_DIR/WebRTC.framework"
    
    if [ -f "$WEBRTC_SRC/out/ios_arm64/gen/sdk/WebRTC.framework/WebRTC/WebRTC.h" ]; then
        cp "$WEBRTC_SRC/out/ios_arm64/gen/sdk/WebRTC.framework/WebRTC/WebRTC.h" "$DEVICE_TEMP_DIR/WebRTC.framework/Headers/"
    else
        echo "⚠️ Warning: WebRTC.h not found for device framework"
    fi
fi

if [ "$BUILD_IOS_SIM" = "true" ] && [ -d "$WEBRTC_SRC/out/ios_sim_arm64/WebRTC.framework" ]; then
    echo "Copying iOS simulator framework..."
    mkdir -p "$SIMULATOR_TEMP_DIR"
    cp -R "$WEBRTC_SRC/out/ios_sim_arm64/WebRTC.framework" "$SIMULATOR_TEMP_DIR/WebRTC.framework"
    
    if [ -f "$WEBRTC_SRC/out/ios_sim_arm64/gen/sdk/WebRTC.framework/WebRTC/WebRTC.h" ]; then
        cp "$WEBRTC_SRC/out/ios_sim_arm64/gen/sdk/WebRTC.framework/WebRTC/WebRTC.h" "$SIMULATOR_TEMP_DIR/WebRTC.framework/Headers/"
    else
        echo "⚠️ Warning: WebRTC.h not found for simulator framework"
    fi
fi

echo "Creating XCFramework..."

XCODEBUILD_CMD="xcodebuild -create-xcframework"
FRAMEWORKS_BUILT=()

if [ "$BUILD_IOS" = "true" ] && [ -d "$DEVICE_TEMP_DIR/WebRTC.framework" ]; then
    FRAMEWORKS_BUILT+=("$DEVICE_TEMP_DIR/WebRTC.framework")
fi

if [ "$BUILD_IOS_SIM" = "true" ] && [ -d "$SIMULATOR_TEMP_DIR/WebRTC.framework" ]; then
    FRAMEWORKS_BUILT+=("$SIMULATOR_TEMP_DIR/WebRTC.framework")
fi

if [ ${#FRAMEWORKS_BUILT[@]} -eq 0 ]; then
    echo "[Package] ❌ Error: No frameworks found to create XCFramework"
    exit 1
fi

for framework in "${FRAMEWORKS_BUILT[@]}"; do
    XCODEBUILD_CMD="$XCODEBUILD_CMD -framework \"$framework\""
done

XCODEBUILD_CMD="$XCODEBUILD_CMD -output \"$OUTPUT_DIR/WebRTC.xcframework\""
eval "$XCODEBUILD_CMD"

echo "XCFramework created: $OUTPUT_DIR/WebRTC.xcframework"


if [ "${ARCHIVE_BUILDS:-true}" = "true" ]; then
    echo "Creating distribution archive..."
    cd "$OUTPUT_DIR"
    zip -r "WebRTC-H265.zip" "WebRTC.xcframework"
    echo "Output: $OUTPUT_DIR/WebRTC-H265.zip"
else
    echo "XCFramework: $OUTPUT_DIR/WebRTC.xcframework"
fi

echo "🔧 Post-processing: Setting up RTCMacros.h structure..."

if [ -d "$OUTPUT_DIR/WebRTC.xcframework" ]; then
    find "$OUTPUT_DIR/WebRTC.xcframework" -name "WebRTC.framework" -type d | while read framework_path; do
        if [ -f "$framework_path/Headers/RTCMacros.h" ]; then
            mkdir -p "$framework_path/Headers/sdk/objc/base"
            cp "$framework_path/Headers/RTCMacros.h" "$framework_path/Headers/sdk/objc/base/"
        fi
    done
fi

rm -rf "$DEVICE_TEMP_DIR" "$SIMULATOR_TEMP_DIR"

echo "🎉 iOS XCFramework with H.265 support successfully created!"
echo "📦 Framework includes:"
if [ "$BUILD_IOS" = "true" ] && [ -d "$OUTPUT_DIR/WebRTC.xcframework/ios-arm64/WebRTC.framework" ]; then
    echo "   - iOS Device (arm64)"
fi
if [ "$BUILD_IOS_SIM" = "true" ] && [ -d "$OUTPUT_DIR/WebRTC.xcframework/ios-arm64-simulator/WebRTC.framework" ]; then
    echo "   - iOS Simulator (arm64)"
fi
echo "   - H.265/HEVC hardware acceleration via VideoToolbox"
echo "   - Minimum iOS version: 13.0"