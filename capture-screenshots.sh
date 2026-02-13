#!/bin/bash
"""
Capture screenshots from an Android device for Google Play Store listing.

This script helps you capture screenshots from your connected Android device
and processes them to meet Play Store requirements.

Requirements:
- Android device connected via USB with USB debugging enabled
- Lyroes app installed and running on the device
- adb installed

Usage:
    ./capture-screenshots.sh [--output-dir DIR] [--count N]
"""

set -e

# Configuration
OUTPUT_DIR="${1:-./playstore-assets/screenshots}"
DEVICE_ID="${2:-}"
SCREENSHOT_COUNT="${3:-4}"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}📱 Lyroes Screenshot Capture Tool${NC}\n"

# Check if adb is available
if ! command -v adb &> /dev/null; then
    echo -e "${RED}Error: adb not found. Please install Android SDK platform-tools.${NC}"
    exit 1
fi

# Check for connected devices
echo -e "${BLUE}Checking for connected devices...${NC}"
DEVICES=$(adb devices | grep -v "List of devices" | grep "device$" | cut -f1)

if [ -z "$DEVICES" ]; then
    echo -e "${RED}Error: No Android device connected.${NC}"
    echo "Please connect your device via USB and enable USB debugging."
    exit 1
fi

DEVICE_COUNT=$(echo "$DEVICES" | wc -l)
if [ "$DEVICE_COUNT" -gt 1 ] && [ -z "$DEVICE_ID" ]; then
    echo -e "${YELLOW}Multiple devices detected:${NC}"
    echo "$DEVICES"
    echo -e "\n${YELLOW}Please specify device ID as second argument.${NC}"
    exit 1
fi

DEVICE_ID=${DEVICE_ID:-$(echo "$DEVICES" | head -n1)}
echo -e "${GREEN}✓ Using device: $DEVICE_ID${NC}\n"

# Create output directory
mkdir -p "$OUTPUT_DIR"
echo -e "${BLUE}Output directory: $OUTPUT_DIR${NC}\n"

# Get device screen resolution
RESOLUTION=$(adb -s "$DEVICE_ID" shell wm size | grep "Physical size" | cut -d: -f2 | tr -d ' ')
echo -e "${BLUE}Device resolution: $RESOLUTION${NC}"

# Check if app is running
PACKAGE_NAME="com.jixter.lyroes"
echo -e "\n${BLUE}Checking if Lyroes is running...${NC}"
if ! adb -s "$DEVICE_ID" shell pidof "$PACKAGE_NAME" &> /dev/null; then
    echo -e "${YELLOW}⚠ Lyroes app is not running. Launching...${NC}"
    adb -s "$DEVICE_ID" shell monkey -p "$PACKAGE_NAME" -c android.intent.category.LAUNCHER 1 &> /dev/null
    sleep 3
fi

echo -e "${GREEN}✓ App is running${NC}\n"

# Function to capture screenshot
capture_screenshot() {
    local index=$1
    local filename="screenshot_${index}.png"
    local device_path="/sdcard/screenshot_temp.png"

    echo -e "${BLUE}📸 Capturing screenshot $index...${NC}"

    # Capture screenshot on device
    adb -s "$DEVICE_ID" shell screencap -p "$device_path"

    # Pull screenshot to computer
    adb -s "$DEVICE_ID" pull "$device_path" "$OUTPUT_DIR/$filename" &> /dev/null

    # Clean up device
    adb -s "$DEVICE_ID" shell rm "$device_path"

    echo -e "${GREEN}   ✓ Saved: $OUTPUT_DIR/$filename${NC}"
}

# Interactive capture
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}INTERACTIVE SCREENSHOT CAPTURE${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo -e "Play Store requires ${BLUE}at least 4 screenshots${NC} (ideally 8)"
echo -e "Recommended screenshots:"
echo "  1. Main game screen / Home screen"
echo "  2. Gameplay in action (guessing lyrics)"
echo "  3. Score/Results screen"
echo "  4. Leaderboard or social features"
echo "  5. Settings or profile screen (optional)"
echo "  6. Premium features (optional)"
echo "  7-8. Additional gameplay moments (optional)"
echo ""
echo -e "${YELLOW}Instructions:${NC}"
echo "  1. Navigate to the screen you want to capture on your device"
echo "  2. Press ENTER when ready to capture"
echo "  3. Repeat for each screenshot"
echo ""

for i in $(seq 1 $SCREENSHOT_COUNT); do
    echo -e "\n${BLUE}━━━ Screenshot $i/$SCREENSHOT_COUNT ━━━${NC}"

    if [ $i -eq 1 ]; then
        echo "Suggested: Main screen / Home screen"
    elif [ $i -eq 2 ]; then
        echo "Suggested: Gameplay (guessing lyrics)"
    elif [ $i -eq 3 ]; then
        echo "Suggested: Score/Results screen"
    elif [ $i -eq 4 ]; then
        echo "Suggested: Leaderboard"
    else
        echo "Suggested: Additional feature screen"
    fi

    echo -e "\n${YELLOW}Navigate to the desired screen on your device...${NC}"
    read -p "Press ENTER when ready to capture (or 'q' to quit): " response

    if [ "$response" = "q" ] || [ "$response" = "Q" ]; then
        echo -e "\n${YELLOW}Capture cancelled.${NC}"
        break
    fi

    capture_screenshot $i
    sleep 1
done

echo -e "\n${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Screenshot capture complete!${NC}\n"

# Check if Python/Pillow is available for processing
if command -v python3 &> /dev/null; then
    VENV_PYTHON="/home/yosac/IdeaProjects/lyroes-mobile/.venv/bin/python3"
    if [ -f "$VENV_PYTHON" ]; then
        echo -e "${BLUE}Processing screenshots to Play Store format...${NC}"
        # Note: Could add Python script here to resize/crop if needed
    fi
fi

echo -e "${BLUE}Screenshots saved to: $OUTPUT_DIR${NC}"
echo ""
echo -e "${YELLOW}Note:${NC} Play Store requirements:"
echo "  • Format: PNG or JPEG"
echo "  • Aspect ratio: 16:9 or 9:16"
echo "  • Size: Between 320px and 3840px per side"
echo "  • Minimum 4 screenshots (3 must be 16:9 or 9:16, 1080px minimum)"
echo ""
echo -e "${GREEN}Next steps:${NC}"
echo "  1. Review screenshots in: $OUTPUT_DIR"
echo "  2. Upload to Play Console"
echo "  3. Add captions/descriptions if desired"
