# Lyroes Play Store Tools

Tools pour générer les assets graphiques et captures d'écran pour la fiche Google Play Store de Lyroes.

## 🎯 Fonctionnalités

- **Génération automatique des assets graphiques** à partir du logo Lyroes
  - Icône de l'application (512x512)
  - Image de présentation (1024x500)
  - Logo Google Play Games (600x400, transparent)
  - Image de présentation Google Play Games (1920x1080)

- **Capture interactive de screenshots** depuis un appareil Android
  - Capture guidée étape par étape
  - Validation automatique des formats Play Store
  - Sauvegarde organisée

## 📋 Prérequis

### Pour la génération d'assets
- Python 3.8+
- Pillow (installé automatiquement avec `make setup`)

### Pour la capture de screenshots
- adb (Android Debug Bridge)
- Appareil Android connecté en USB
- Débogage USB activé sur l'appareil
- Application Lyroes installée sur l'appareil

## 🚀 Installation

```bash
# Cloner le repository
git clone https://github.com/YoannSACHOT/lyroes-playstore-tools.git
cd lyroes-playstore-tools

# Installer les dépendances
make setup
```

## 📖 Usage

### Génération des assets graphiques

```bash
# Générer tous les assets depuis le logo Lyroes
make generate-assets

# Ou directement avec Python
python3 generate-playstore-assets.py --logo-path /path/to/logo.png
```

**Sorties générées** (dans `./output/`) :
- `app-icon-512.png` - Icône de l'application (512x512)
- `feature-graphic-1024x500.png` - Image de présentation (1024x500)
- `play-games-logo-600x400.png` - Logo Google Play Games (600x400, transparent)
- `play-games-feature-1920x1080.png` - Image Google Play Games (1920x1080)

### Capture de screenshots

```bash
# Lancer la capture interactive
make capture-screenshots

# Ou directement avec le script
./capture-screenshots.sh
```

**Instructions de capture** :
1. Connectez votre appareil Android en USB
2. Assurez-vous que le débogage USB est activé
3. Lancez l'application Lyroes
4. Exécutez `make capture-screenshots`
5. Suivez les instructions interactives pour capturer chaque écran

**Screenshots recommandés** :
1. Écran principal / Accueil
2. Gameplay en action (deviner les paroles)
3. Écran de score/résultats
4. Classement ou fonctionnalités sociales
5. Paramètres ou profil (optionnel)
6. Fonctionnalités premium (optionnel)
7-8. Moments de gameplay supplémentaires (optionnel)

## 📐 Spécifications Google Play Store

### Icône de l'application
- Format : PNG ou JPEG
- Taille : 512x512 px
- Taille max : 1 Mo

### Image de présentation
- Format : PNG ou JPEG
- Taille : 1024x500 px
- Taille max : 15 Mo

### Screenshots téléphone
- Format : PNG ou JPEG
- Ratio : 16:9 ou 9:16
- Taille : Entre 320px et 3840px par côté
- Minimum : 4 screenshots (dont 3 en 16:9 ou 9:16, résolution min 1080px)
- Taille max par image : 8 Mo

### Logo Google Play Games
- Format : PNG transparent
- Taille : 600x400 px
- Taille max : 8 Mo
- Doit représenter le nom du jeu

### Image Google Play Games
- Format : PNG ou JPEG
- Ratio : 16:9
- Taille : Entre 720px et 7680px par côté
- Taille max : 15 Mo
- Doit représenter la couverture du jeu (sans texte)

## 🛠️ Commandes Make disponibles

```bash
make setup              # Installer les dépendances Python
make generate-assets    # Générer les assets graphiques
make capture-screenshots # Capturer les screenshots interactivement
make clean             # Nettoyer les fichiers générés
make help              # Afficher l'aide
```

## 📂 Structure du projet

```
lyroes-playstore-tools/
├── README.md                      # Ce fichier
├── generate-playstore-assets.py   # Script de génération d'assets
├── capture-screenshots.sh         # Script de capture de screenshots
├── requirements.txt               # Dépendances Python
├── Makefile                       # Commandes utilitaires
├── .gitignore                     # Fichiers à ignorer par Git
└── output/                        # Dossier de sortie (gitignored)
    ├── app-icon-512.png
    ├── feature-graphic-1024x500.png
    ├── play-games-logo-600x400.png
    ├── play-games-feature-1920x1080.png
    └── screenshots/
        ├── screenshot_1.png
        ├── screenshot_2.png
        └── ...
```

## 🎨 Personnalisation

### Modifier les couleurs du gradient

Éditez `generate-playstore-assets.py` et modifiez les valeurs RGB dans les fonctions :
- `create_feature_graphic()` - Pour l'image de présentation
- `create_play_games_feature()` - Pour l'image Google Play Games

### Ajuster la taille du logo

Modifiez les variables `logo_height` dans les fonctions correspondantes.

## 🐛 Dépannage

### "Error: adb not found"
Installez Android SDK Platform Tools :
```bash
# Sur Ubuntu/Debian
sudo apt install android-tools-adb

# Sur macOS
brew install android-platform-tools
```

### "Error: No Android device connected"
1. Connectez votre appareil via USB
2. Activez le débogage USB dans les options développeur
3. Autorisez l'ordinateur sur l'appareil quand demandé
4. Vérifiez avec `adb devices`

### "ModuleNotFoundError: No module named 'PIL'"
Installez les dépendances :
```bash
make setup
# ou
python3 -m venv venv
source venv/bin/activate  # ou venv\Scripts\activate sur Windows
pip install -r requirements.txt
```

## 📝 Licence

Privé - Usage interne Lyroes uniquement

## 👤 Auteur

Yoann SACHOT - [YoannSACHOT](https://github.com/YoannSACHOT)

## 🔗 Liens

- [Lyroes Backend](https://github.com/YoannSACHOT/lyroes)
- [Lyroes Web GUI](https://github.com/YoannSACHOT/lyroes-web-gui)
- [Lyroes Mobile](https://github.com/YoannSACHOT/lyroes-mobile)
- [Google Play Console](https://play.google.com/console)
