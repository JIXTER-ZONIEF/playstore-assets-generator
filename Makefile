.PHONY: help setup generate-assets capture-screenshots clean

PYTHON := python3
VENV := venv
VENV_BIN := $(VENV)/bin
PIP := $(VENV_BIN)/pip
PYTHON_VENV := $(VENV_BIN)/python3

# Configuration (adjust these paths for your project)
LOGO_PATH ?= ./logo.png
OUTPUT_DIR := ./output
PACKAGE_NAME ?=

help: ## Show this help
	@echo "Play Store Assets Generator - Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""

setup: ## Install Python dependencies
	@echo "🔧 Installing dependencies..."
	@if [ ! -d "$(VENV)" ]; then \
		echo "Creating virtual environment..."; \
		$(PYTHON) -m venv $(VENV); \
	fi
	@echo "Installing Pillow..."
	@$(PIP) install -q -r requirements.txt
	@echo "✅ Installation complete!"

generate-assets: setup ## Generate Play Store assets from logo
	@echo "🎨 Generating Play Store assets..."
	@if [ ! -f "$(LOGO_PATH)" ]; then \
		echo "❌ Error: Logo not found at $(LOGO_PATH)"; \
		echo "   Please set LOGO_PATH in Makefile or provide path with: make generate-assets LOGO_PATH=/path/to/logo.png"; \
		exit 1; \
	fi
	@mkdir -p $(OUTPUT_DIR)
	@$(PYTHON_VENV) generate-playstore-assets.py --logo-path $(LOGO_PATH) --output-dir $(OUTPUT_DIR)

capture-screenshots: ## Capture screenshots from Android device
	@echo "📱 Starting screenshot capture..."
	@mkdir -p $(OUTPUT_DIR)/screenshots
	@if [ -z "$(PACKAGE_NAME)" ]; then \
		./capture-screenshots.sh $(OUTPUT_DIR)/screenshots; \
	else \
		./capture-screenshots.sh $(OUTPUT_DIR)/screenshots "" $(PACKAGE_NAME); \
	fi

clean: ## Clean generated files
	@echo "🧹 Cleaning..."
	@rm -rf $(OUTPUT_DIR)
	@rm -rf $(VENV)
	@echo "✅ Cleanup complete!"
