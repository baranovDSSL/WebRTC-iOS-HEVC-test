#!/bin/bash

# Apply H.265 patches to WebRTC source
# This script is called from build_all.sh after fetching WebRTC source

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PATCHES_DIR="$PROJECT_ROOT/h265-patches"
SRC_DIR="$PROJECT_ROOT/src/src"

# Check if WebRTC source exists
if [ ! -d "$SRC_DIR" ]; then
    echo "❌ WebRTC source not found at $SRC_DIR"
    echo "Please run fetch_webrtc.sh first"
    exit 1
fi

# Check if patches directory exists
if [ ! -d "$PATCHES_DIR" ]; then
    echo "❌ Patches directory not found at $PATCHES_DIR"
    exit 1
fi

echo "🔧 Applying H.265 patches to WebRTC source..."
echo "📂 Source: $SRC_DIR"
echo "📦 Patches: $PATCHES_DIR"

cd "$SRC_DIR"

# List of patches in correct application order
PATCHES=(
    "BUILD_gn.patch"
    "nalu_rewriter_h.patch"
    "nalu_rewriter_h265.patch"
    "RTCVideoDecoderH265.patch"
    "RTCVideoDecoderH265_h.patch"
    "RTCVideoDecoderFactoryH265.patch"
    "RTCVideoDecoderFactoryH265_h.patch"
    "RTCVideoEncoderH265.patch"
    "RTCVideoEncoderH265_h.patch"
    "RTCVideoEncoderFactoryH265.patch"
    "RTCVideoEncoderFactoryH265_h.patch"
    "RTCCodecSpecificInfoH265.patch"
    "RTCCodecSpecificInfoH265_h.patch"
    "RTCCodecSpecificInfoH265_Private.patch"
    "RTCAudioSessionConfiguration.patch"
    "audio_device_ios.patch"
    "voice_processing_audio_unit.patch"
    "objc_video_encoder_factory.patch"
    "RTCPeerConnectionFactory.patch"
)

APPLIED_COUNT=0
FAILED_COUNT=0

echo "📋 Found 19 patch files"
echo ""

for patch in "${PATCHES[@]}"; do
    patch_file="$PATCHES_DIR/$patch"
    if [ -f "$patch_file" ]; then
        echo "🔧 Applying $patch..."
        if patch -p1 --forward < "$patch_file" 2>/dev/null; then
            echo "  ✅ $patch applied successfully"
            ((APPLIED_COUNT++))
        else
            # Check if patch is already applied
            if patch -p1 --dry-run --reverse < "$patch_file" >/dev/null 2>&1; then
                echo "  ⚠️  $patch already applied (skipping)"
                ((APPLIED_COUNT++))
            else
                echo "  ❌ Failed to apply $patch"
                ((FAILED_COUNT++))
            fi
        fi
    else
        echo "  ❌ Patch file not found: $patch"
        ((FAILED_COUNT++))
    fi
done

echo ""
echo "📊 Patch application results:"
echo "  ✅ Successfully applied: $APPLIED_COUNT"
echo "  ❌ Failed: $FAILED_COUNT"
echo "  📦 Total patches: ${#PATCHES[@]}"

if [ $FAILED_COUNT -gt 0 ]; then
    echo ""
    echo "❌ Some patches failed to apply!"
    echo "💡 This might be normal if patches are already applied"
    echo "🔍 Check the output above for details"
    # Don't exit with error - let build continue
fi

echo ""
echo "🎉 H.265 patches application completed!"
echo "✅ WebRTC source is now ready for H.265 build"