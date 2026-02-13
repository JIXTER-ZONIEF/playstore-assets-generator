.PHONY: help setup generate-assets capture-screenshots clean

PYTHON := python3
VENV := venv
VENV_BIN := $(VENV)/bin
PIP := $(VENV_BIN)/pip
PYTHON_VENV := $(VENV_BIN)/python3

# Default logo path (adjust if needed)
LOGO_PATH := ../lyroes-web-gui/public/assets/logo.png
OUTPUT_DIR := ./output

help: ## Afficher cette aide
	@echo "Lyroes Play Store Tools - Commandes disponibles:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""

setup: ## Installer les dépendances Python
	@echo "🔧 Installation des dépendances..."
	@if [ ! -d "$(VENV)" ]; then \
		echo "Création de l'environnement virtuel..."; \
		$(PYTHON) -m venv $(VENV); \
	fi
	@echo "Installation de Pillow..."
	@$(PIP) install -q -r requirements.txt
	@echo "✅ Installation terminée!"

generate-assets: setup ## Générer les assets graphiques depuis le logo
	@echo "🎨 Génération des assets Play Store..."
	@mkdir -p $(OUTPUT_DIR)
	@$(PYTHON_VENV) generate-playstore-assets.py --logo-path $(LOGO_PATH) --output-dir $(OUTPUT_DIR)

capture-screenshots: ## Capturer les screenshots de l'appareil Android
	@echo "📱 Lancement de la capture de screenshots..."
	@mkdir -p $(OUTPUT_DIR)/screenshots
	@./capture-screenshots.sh $(OUTPUT_DIR)/screenshots

clean: ## Nettoyer les fichiers générés
	@echo "🧹 Nettoyage..."
	@rm -rf $(OUTPUT_DIR)
	@rm -rf $(VENV)
	@echo "✅ Nettoyage terminé!"

test-assets: setup ## Tester la génération d'assets (avec logo de test)
	@echo "🧪 Test de génération..."
	@$(PYTHON_VENV) generate-playstore-assets.py --help
