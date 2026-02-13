# Play Store Assets Generator

Automated tools to generate graphic assets and capture screenshots for your Google Play Store listing.

## 🎯 Features

- **Automatic graphic asset generation** from your app logo
  - App icon (512x512)
  - Feature graphic (1024x500)
  - Google Play Games logo (600x400, transparent)
  - Google Play Games feature graphic (1920x1080)

- **Interactive screenshot capture** from Android devices
  - Step-by-step guided capture
  - Automatic Play Store format validation
  - Organized output structure

## 📋 Prerequisites

### For asset generation
- Python 3.8+
- Pillow (automatically installed with `make setup`)

### For screenshot capture
- adb (Android Debug Bridge)
- Android device connected via USB
- USB debugging enabled on device
- Your app installed on the device

## 🚀 Installation

```bash
# Clone the repository
git clone https://github.com/YoannSACHOT/playstore-assets-generator.git
cd playstore-assets-generator

# Install dependencies
make setup
```

## 📖 Usage

### Generating graphic assets

```bash
# Generate all assets from your logo
make generate-assets LOGO_PATH=/path/to/your/logo.png

# Or directly with Python
python3 generate-playstore-assets.py --logo-path /path/to/logo.png
```

**Generated outputs** (in `./output/`):
- `app-icon-512.png` - App icon (512x512)
- `feature-graphic-1024x500.png` - Feature graphic (1024x500)
- `play-games-logo-600x400.png` - Play Games logo (600x400, transparent)
- `play-games-feature-1920x1080.png` - Play Games feature (1920x1080)

### Capturing screenshots

```bash
# Launch interactive capture
make capture-screenshots

# Or with specific package name
make capture-screenshots PACKAGE_NAME=com.yourcompany.yourapp

# Or directly with the script
./capture-screenshots.sh ./output/screenshots "" com.yourcompany.yourapp
```

**Capture instructions**:
1. Connect your Android device via USB
2. Ensure USB debugging is enabled
3. Launch your app on the device
4. Run `make capture-screenshots`
5. Follow the interactive prompts to capture each screen

**Recommended screenshots**:
1. Main screen / Home screen
2. Gameplay or main feature in action
3. Results or achievements screen
4. Leaderboard or social features
5. Settings or profile screen (optional)
6. Premium features (optional)
7-8. Additional feature highlights (optional)

## 📐 Google Play Store Specifications

### App Icon
- Format: PNG or JPEG
- Size: 512x512 px
- Max file size: 1 MB

### Feature Graphic
- Format: PNG or JPEG
- Size: 1024x500 px
- Max file size: 15 MB

### Phone Screenshots
- Format: PNG or JPEG
- Aspect ratio: 16:9 or 9:16
- Size: Between 320px and 3840px per side
- Minimum: 4 screenshots (3 must be 16:9 or 9:16, min 1080px resolution)
- Max file size per image: 8 MB

### Google Play Games Logo
- Format: Transparent PNG
- Size: 600x400 px
- Max file size: 8 MB
- Must represent the game name

### Google Play Games Feature
- Format: PNG or JPEG
- Aspect ratio: 16:9
- Size: Between 720px and 7680px per side
- Max file size: 15 MB
- Must represent the game cover (no text)

## 🛠️ Available Make Commands

```bash
make setup              # Install Python dependencies
make generate-assets    # Generate graphic assets from logo
make capture-screenshots # Capture screenshots interactively
make clean             # Clean generated files
make help              # Show help
```

## 📂 Project Structure

```
playstore-assets-generator/
├── README.md                      # This file
├── generate-playstore-assets.py   # Asset generation script
├── capture-screenshots.sh         # Screenshot capture script
├── quick-capture.sh              # Quick capture (timed)
├── requirements.txt               # Python dependencies
├── Makefile                       # Utility commands
├── .gitignore                     # Files to ignore by Git
└── output/                        # Output folder (gitignored)
    ├── app-icon-512.png
    ├── feature-graphic-1024x500.png
    ├── play-games-logo-600x400.png
    ├── play-games-feature-1920x1080.png
    └── screenshots/
        ├── screenshot_1.png
        ├── screenshot_2.png
        └── ...
```

## 🎨 Customization

### Modifying gradient colors

Edit `generate-playstore-assets.py` and modify the RGB values in:
- `create_feature_graphic()` - For the feature graphic
- `create_play_games_feature()` - For the Play Games feature

Current default: Purple (#6366f1) to Blue (#3b82f6) gradient

### Adjusting logo size

Modify the `logo_height` variables in the corresponding functions.

## 🐛 Troubleshooting

### "Error: adb not found"
Install Android SDK Platform Tools:
```bash
# On Ubuntu/Debian
sudo apt install android-tools-adb

# On macOS
brew install android-platform-tools

# On Windows
# Download from https://developer.android.com/studio/releases/platform-tools
```

### "Error: No Android device connected"
1. Connect your device via USB
2. Enable USB debugging in developer options
3. Authorize the computer on the device when prompted
4. Verify with `adb devices`

### "ModuleNotFoundError: No module named 'PIL'"
Install dependencies:
```bash
make setup
# or
python3 -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows
pip install -r requirements.txt
```

### "Error: Logo not found"
Make sure to provide the correct path to your logo:
```bash
make generate-assets LOGO_PATH=/path/to/your/logo.png
```

## 📝 License

MIT License - Feel free to use this tool for your own projects!

## 👤 Author

Yoann SACHOT - [YoannSACHOT](https://github.com/YoannSACHOT)

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

## ⭐ Show your support

Give a ⭐ if this project helped you!

## 🔗 Related Links

- [Google Play Console](https://play.google.com/console)
- [Google Play Store Listing Guidelines](https://support.google.com/googleplay/android-developer/answer/9866151)
- [Android Asset Studio](https://romannurik.github.io/AndroidAssetStudio/)
