#!/bin/bash

# Platform Configuration
export BUILD_IOS="${BUILD_IOS:-true}"                  # Build for iOS devices
export BUILD_IOS_SIM="${BUILD_IOS_SIM:-true}"         # Build for iOS Simulator

# Video Codec Configuration
export ENABLE_H265="${ENABLE_H265:-true}"              # Enable H265/HEVC codec
export ENABLE_VP9="${ENABLE_VP9:-true}"                # Enable VP9 codec
export ENABLE_AV1="${ENABLE_AV1:-false}"               # Enable AV1 codec (disabled for size)

# Audio Codec Configuration
export ENABLE_OPUS="${ENABLE_OPUS:-true}"              # Enable Opus audio codec
export ENABLE_G711="${ENABLE_G711:-true}"              # Enable G.711 audio codec (PCMU/PCMA)
export ENABLE_G722="${ENABLE_G722:-true}"              # Enable G.722 audio codec
export ENABLE_ILBC="${ENABLE_ILBC:-true}"              # Enable iLBC audio codec
export ENABLE_ISAC="${ENABLE_ISAC:-true}"              # Enable iSAC audio codec

# Optimization Configuration
export ENABLE_LTO="${ENABLE_LTO:-true}"                # Enable Link-Time Optimization
export ENABLE_THIN_LTO="${ENABLE_THIN_LTO:-true}"      # Use Thin LTO (faster than full LTO)
export OPTIMIZE_FOR_SIZE="${OPTIMIZE_FOR_SIZE:-true}"  # Optimize for binary size
export STRIP_SYMBOLS="${STRIP_SYMBOLS:-false}"         # Strip debug symbols (disabled for debugging)
export SYMBOL_LEVEL="${SYMBOL_LEVEL:-2}"               # Symbol level (0=none, 1=minimal, 2=full)
export ENABLE_METRICS="${ENABLE_METRICS:-false}"       # Enable metrics collection (disabled for size)

# Feature Configuration
export ENABLE_SCTP="${ENABLE_SCTP:-true}"             # Enable SCTP for data channels
export ENABLE_EXTERNAL_AUTH="${ENABLE_EXTERNAL_AUTH:-true}" # Enable external auth

# Output Configuration
export OUTPUT_DIR="${OUTPUT_DIR:-output}"              # Output directory for built frameworks
export ARCHIVE_BUILDS="${ARCHIVE_BUILDS:-true}"        # Create zip archives of builds

# Logging Configuration
export VERBOSE_BUILD="${VERBOSE_BUILD:-false}"         # Enable verbose build output

# Framework Naming Configuration
export FRAMEWORK_NAME="${FRAMEWORK_NAME:-WebRTCLib}"   # Framework name (WebRTCLib.framework)
export MODULE_NAME="${MODULE_NAME:-WebRTCLib}"         # Module name (for import statements)

# Print configuration summary
print_config() {
    echo "=== WebRTC Build Configuration ==="
    echo "Platforms:"
    echo "  iOS Device: $BUILD_IOS"
    echo "  iOS Simulator: $BUILD_IOS_SIM"
    echo ""
    echo "Video Codecs:"
    echo "  H265/HEVC: $ENABLE_H265"
    echo "  VP9: $ENABLE_VP9"
    echo "  AV1: $ENABLE_AV1"
    echo ""
    echo "Audio Codecs:"
    echo "  Opus: $ENABLE_OPUS"
    echo "  G.711 (PCMU/PCMA): $ENABLE_G711"
    echo "  G.722: $ENABLE_G722"
    echo "  iLBC: $ENABLE_ILBC"
    echo "  iSAC: $ENABLE_ISAC"
    echo ""
    echo "Optimizations:"
    echo "  LTO: $ENABLE_LTO"
    echo "  Thin LTO: $ENABLE_THIN_LTO"
    echo "  Size Optimization: $OPTIMIZE_FOR_SIZE"
    echo "  Strip Symbols: $STRIP_SYMBOLS"
    echo "  Symbol Level: $SYMBOL_LEVEL"
    echo "  Disable Metrics: $ENABLE_METRICS"
    echo ""
    echo "Features:"
    echo "  Data Channels (SCTP): $ENABLE_SCTP"
    echo "  External Auth: $ENABLE_EXTERNAL_AUTH"
    echo ""
    echo "Output:"
    echo "  Directory: $OUTPUT_DIR"
    echo "  Create Archives: $ARCHIVE_BUILDS"
    echo "  Verbose Build: $VERBOSE_BUILD"
    echo "================================="
}