#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[$(date '+%H:%M:%S')]${NC} $1"
}

print_error() {
    echo -e "${RED}[$(date '+%H:%M:%S')] ERROR:${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[$(date '+%H:%M:%S')] WARNING:${NC} $1"
}

check_requirements() {
    print_status "Checking system requirements..."
    
    os_version=$(sw_vers -productVersion)
    print_status "macOS version: $os_version"
    
    arch=$(uname -m)
    print_status "Development architecture: $arch"
    
    if ! xcode-select -p &> /dev/null; then
        print_error "Xcode command line tools not installed. Please run: xcode-select --install"
        exit 1
    fi
    print_status "Xcode: $(xcodebuild -version | head -1) ✓"
    
    available_space=$(df -H / | awk 'NR==2 {print $4}' | sed 's/G//')
    if (( $(echo "$available_space < 60" | bc -l) )); then
        print_warning "Low disk space: ${available_space}GB available. Recommended: 60GB+"
    fi
    
    if ! command -v python3 &> /dev/null; then
        print_error "Python 3 is required. Please install it via Homebrew: brew install python3"
        exit 1
    fi
    print_status "Python 3: $(python3 --version) ✓"
}

main() {
    print_status "Starting WebRTC build process..."
    print_warning "This will take 1-3 hours depending on your internet speed and Mac performance."
    
    check_requirements
    
    if [ -f "$PROJECT_ROOT/build_config.sh" ]; then
        source "$PROJECT_ROOT/build_config.sh"
        print_status "Build configuration loaded"
        if [ "$VERBOSE_BUILD" = "true" ]; then
            print_config
        fi
    fi
    
    print_status "Step 1/5: Setting up depot_tools..."
    if [ ! -d "$PROJECT_ROOT/depot_tools" ]; then
        "$PROJECT_ROOT/scripts/setup_depot_tools.sh"
    else
        print_status "depot_tools already exists, skipping setup"
    fi
    export PATH="$PROJECT_ROOT/depot_tools:$PATH"
    
    print_status "Step 2/5: Fetching WebRTC source code..."
    print_warning "This will download ~20GB of data"
    "$PROJECT_ROOT/scripts/fetch_webrtc.sh"
    
    print_status "Step 3/5: Applying H.265 patches..."
    "$PROJECT_ROOT/scripts/apply_h265_patches.sh"
    
    print_status "Step 4/5: Building WebRTC for iOS..."
    print_warning "This will take 30-60 minutes"
    "$PROJECT_ROOT/scripts/build_ios.sh"
    
    print_status "Step 5/5: Packaging framework..."
    "$PROJECT_ROOT/scripts/package_framework.sh"
    
    print_status "Build completed successfully! 🎉"
    print_status "Output files:"
    echo "  - XCFramework: $PROJECT_ROOT/output/WebRTC.xcframework"
    echo "  - Compressed: $PROJECT_ROOT/output/WebRTC-H265.zip"
    print_status "Framework details:"
    echo "  - Size: $(ls -lh "$PROJECT_ROOT/output/WebRTC-H265.zip" | awk '{print $5}')"
    echo "  - Architecture: arm64 (iOS device and simulator)"
    echo "  - H265 Support: Enabled"
}

# Run main function
main "$@"