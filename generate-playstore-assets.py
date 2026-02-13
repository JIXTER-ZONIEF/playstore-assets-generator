#!/usr/bin/env python3
"""
Generate Google Play Store assets from the Lyroes logo.

This script generates all required images for the Google Play Store listing:
- App icon (512x512)
- Feature graphic (1024x500)
- Google Play Games logo (600x400, transparent PNG)
- Google Play Games feature graphic (1920x1080)

Usage:
    python3 generate-playstore-assets.py [--logo-path PATH] [--output-dir DIR]
"""

import argparse
import os
import sys
from pathlib import Path

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    print("Error: Pillow library not found. Install it with:")
    print("  pip3 install Pillow")
    sys.exit(1)


def create_app_icon(logo_img, output_path):
    """Create 512x512 app icon."""
    print("  Creating app icon (512x512)...")
    icon = logo_img.resize((512, 512), Image.Resampling.LANCZOS)
    icon.save(output_path, "PNG", optimize=True)
    print(f"    ✓ Saved: {output_path}")


def create_feature_graphic(logo_img, output_path):
    """Create 1024x500 feature graphic with gradient background."""
    print("  Creating feature graphic (1024x500)...")

    # Create gradient background
    width, height = 1024, 500
    feature = Image.new("RGB", (width, height))
    draw = ImageDraw.Draw(feature)

    # Gradient from dark purple to blue (Lyroes theme colors)
    for y in range(height):
        # Purple (#6366f1) to Blue (#3b82f6)
        r = int(99 + (59 - 99) * (y / height))
        g = int(102 + (130 - 102) * (y / height))
        b = int(241 + (246 - 241) * (y / height))
        draw.rectangle([(0, y), (width, y + 1)], fill=(r, g, b))

    # Convert to RGBA to support transparency
    feature = feature.convert("RGBA")

    # Resize and center logo
    logo_height = 350  # Use most of the height
    logo_width = int(logo_img.width * (logo_height / logo_img.height))
    logo_resized = logo_img.resize((logo_width, logo_height), Image.Resampling.LANCZOS)

    # Center logo
    x = (width - logo_width) // 2
    y = (height - logo_height) // 2

    # Paste logo with alpha
    feature.paste(logo_resized, (x, y), logo_resized if logo_resized.mode == 'RGBA' else None)

    # Convert back to RGB for JPEG compatibility
    feature = feature.convert("RGB")
    feature.save(output_path, "PNG", optimize=True)
    print(f"    ✓ Saved: {output_path}")


def create_play_games_logo(logo_img, output_path):
    """Create 600x400 transparent logo for Google Play Games."""
    print("  Creating Play Games logo (600x400, transparent)...")

    # Create transparent background
    canvas = Image.new("RGBA", (600, 400), (0, 0, 0, 0))

    # Resize logo to fit within canvas with padding
    max_width, max_height = 500, 300
    logo_width, logo_height = logo_img.size
    ratio = min(max_width / logo_width, max_height / logo_height)
    new_width = int(logo_width * ratio)
    new_height = int(logo_height * ratio)

    logo_resized = logo_img.resize((new_width, new_height), Image.Resampling.LANCZOS)

    # Center logo
    x = (600 - new_width) // 2
    y = (400 - new_height) // 2

    canvas.paste(logo_resized, (x, y), logo_resized if logo_resized.mode == 'RGBA' else None)
    canvas.save(output_path, "PNG", optimize=True)
    print(f"    ✓ Saved: {output_path}")


def create_play_games_feature(logo_img, output_path):
    """Create 1920x1080 feature graphic for Google Play Games (16:9)."""
    print("  Creating Play Games feature graphic (1920x1080)...")

    # Create gradient background
    width, height = 1920, 1080
    feature = Image.new("RGB", (width, height))
    draw = ImageDraw.Draw(feature)

    # Darker gradient for gaming aesthetic
    for y in range(height):
        # Dark purple to darker blue
        r = int(75 + (45 - 75) * (y / height))
        g = int(85 + (100 - 85) * (y / height))
        b = int(200 + (210 - 200) * (y / height))
        draw.rectangle([(0, y), (width, y + 1)], fill=(r, g, b))

    feature = feature.convert("RGBA")

    # Resize logo
    logo_height = 700
    logo_width = int(logo_img.width * (logo_height / logo_img.height))
    logo_resized = logo_img.resize((logo_width, logo_height), Image.Resampling.LANCZOS)

    # Center logo
    x = (width - logo_width) // 2
    y = (height - logo_height) // 2

    feature.paste(logo_resized, (x, y), logo_resized if logo_resized.mode == 'RGBA' else None)

    feature = feature.convert("RGB")
    feature.save(output_path, "PNG", optimize=True)
    print(f"    ✓ Saved: {output_path}")


def main():
    parser = argparse.ArgumentParser(
        description="Generate Google Play Store assets from Lyroes logo"
    )
    parser.add_argument(
        "--logo-path",
        default="../lyroes-web-gui/public/assets/logo.png",
        help="Path to the source logo (default: ../lyroes-web-gui/public/assets/logo.png)",
    )
    parser.add_argument(
        "--output-dir",
        default="./playstore-assets",
        help="Output directory for generated assets (default: ./playstore-assets)",
    )

    args = parser.parse_args()

    # Resolve paths
    logo_path = Path(args.logo_path).resolve()
    output_dir = Path(args.output_dir).resolve()

    # Check logo exists
    if not logo_path.exists():
        print(f"Error: Logo not found at {logo_path}")
        sys.exit(1)

    # Create output directory
    output_dir.mkdir(parents=True, exist_ok=True)

    print(f"Loading logo from: {logo_path}")
    print(f"Output directory: {output_dir}\n")

    # Load logo
    try:
        logo_img = Image.open(logo_path)
        if logo_img.mode != 'RGBA':
            logo_img = logo_img.convert('RGBA')
        print(f"Logo loaded: {logo_img.size[0]}x{logo_img.size[1]} px\n")
    except Exception as e:
        print(f"Error loading logo: {e}")
        sys.exit(1)

    # Generate all assets
    print("Generating Play Store assets...\n")

    create_app_icon(logo_img, output_dir / "app-icon-512.png")
    create_feature_graphic(logo_img, output_dir / "feature-graphic-1024x500.png")
    create_play_games_logo(logo_img, output_dir / "play-games-logo-600x400.png")
    create_play_games_feature(logo_img, output_dir / "play-games-feature-1920x1080.png")

    print("\n✅ All assets generated successfully!")
    print(f"\nAssets location: {output_dir}")
    print("\nGenerated files:")
    print("  • app-icon-512.png              (App icon - 512x512)")
    print("  • feature-graphic-1024x500.png  (Feature graphic - 1024x500)")
    print("  • play-games-logo-600x400.png   (Play Games logo - 600x400, transparent)")
    print("  • play-games-feature-1920x1080.png (Play Games feature - 1920x1080)")
    print("\nNote: You still need to create screenshots manually from your app.")


if __name__ == "__main__":
    main()
