#!/bin/bash
# Quick screenshot capture - captures current screen every 10 seconds

OUTPUT_DIR="${1:-./output/screenshots}"
COUNT="${2:-4}"

mkdir -p "$OUTPUT_DIR"

echo "📱 Quick Screenshot Capture"
echo "Output: $OUTPUT_DIR"
echo ""
echo "Ready to capture $COUNT screenshots."
echo "Navigate through your app screens manually."
echo "A screenshot will be captured every 10 seconds."
echo ""
read -p "Press ENTER to start..."

for i in $(seq 1 $COUNT); do
    echo ""
    echo "[$i/$COUNT] Capturing in 3 seconds..."
    echo "       (Navigate to the screen you want to capture now)"
    sleep 3

    filename="screenshot_${i}.png"
    adb shell screencap -p /sdcard/screenshot_temp.png
    adb pull /sdcard/screenshot_temp.png "$OUTPUT_DIR/$filename" > /dev/null 2>&1
    adb shell rm /sdcard/screenshot_temp.png

    echo "       ✓ Captured: $filename"

    if [ $i -lt $COUNT ]; then
        echo "       Next capture in 7 seconds..."
        sleep 7
    fi
done

echo ""
echo "✅ Done! Screenshots saved to: $OUTPUT_DIR"
