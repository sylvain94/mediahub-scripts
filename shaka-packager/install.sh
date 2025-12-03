#!/bin/bash

###############################################################################
# Script d'installation automatique de Shaka Packager pour Linux
# Télécharge et installe la dernière version précompilée
###############################################################################

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}########################################${NC}"
echo -e "${GREEN}## Installation de Shaka Packager ##${NC}"
echo -e "${GREEN}########################################${NC}"
echo

# Vérifier si on est root ou utiliser sudo
if [ "$EUID" -ne 0 ]; then 
    SUDO_CMD="sudo"
    echo -e "${YELLOW}Note: Certaines commandes nécessitent les droits root${NC}"
else
    SUDO_CMD=""
fi

# Vérifier les dépendances
echo "Vérification des dépendances..."
if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
    echo -e "${RED}Erreur: curl ou wget est requis pour télécharger le binaire${NC}"
    echo "Installation de curl..."
    $SUDO_CMD apt-get update && $SUDO_CMD apt-get install -y curl
fi

# Détecter l'architecture
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    ARCH_SUFFIX="x64"
elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    ARCH_SUFFIX="arm64"
else
    echo -e "${RED}Erreur: Architecture non supportée: $ARCH${NC}"
    exit 1
fi

echo "Architecture détectée: $ARCH ($ARCH_SUFFIX)"
echo

# Récupérer la dernière version
echo "Récupération de la dernière version..."
if command -v curl &> /dev/null; then
    LATEST_VERSION=$(curl -s https://api.github.com/repos/shaka-project/shaka-packager/releases/latest | grep "tag_name" | cut -d '"' -f 4)
else
    LATEST_VERSION=$(wget -qO- https://api.github.com/repos/shaka-project/shaka-packager/releases/latest | grep "tag_name" | cut -d '"' -f 4)
fi

if [ -z "$LATEST_VERSION" ]; then
    echo -e "${RED}Erreur: Impossible de récupérer la version${NC}"
    exit 1
fi

echo -e "${GREEN}Dernière version trouvée: $LATEST_VERSION${NC}"
echo

# URL de téléchargement
DOWNLOAD_URL="https://github.com/shaka-project/shaka-packager/releases/download/${LATEST_VERSION}/packager-linux-${ARCH_SUFFIX}"
TEMP_DIR=$(mktemp -d)
BINARY_NAME="packager-linux-${ARCH_SUFFIX}"

# Télécharger
echo "Téléchargement de Shaka Packager..."
cd "$TEMP_DIR"

if command -v curl &> /dev/null; then
    curl -L -o "$BINARY_NAME" "$DOWNLOAD_URL"
else
    wget -O "$BINARY_NAME" "$DOWNLOAD_URL"
fi

if [ ! -f "$BINARY_NAME" ]; then
    echo -e "${RED}Erreur: Échec du téléchargement${NC}"
    exit 1
fi

# Rendre exécutable
chmod +x "$BINARY_NAME"

# Vérifier que le binaire fonctionne
echo "Vérification du binaire..."
if ! "$TEMP_DIR/$BINARY_NAME" --version &> /dev/null; then
    echo -e "${RED}Erreur: Le binaire téléchargé ne fonctionne pas${NC}"
    exit 1
fi

VERSION=$("$TEMP_DIR/$BINARY_NAME" --version)
echo -e "${GREEN}Binaire vérifié: $VERSION${NC}"
echo

# Installer dans /usr/local/bin
INSTALL_DIR="/usr/local/bin"
INSTALL_PATH="$INSTALL_DIR/packager"

echo "Installation dans $INSTALL_PATH..."

# Sauvegarder l'ancienne version si elle existe
if [ -f "$INSTALL_PATH" ]; then
    echo -e "${YELLOW}Une version existante a été trouvée${NC}"
    BACKUP_PATH="${INSTALL_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
    $SUDO_CMD mv "$INSTALL_PATH" "$BACKUP_PATH"
    echo "Ancienne version sauvegardée dans: $BACKUP_PATH"
fi

# Copier le nouveau binaire
$SUDO_CMD cp "$BINARY_NAME" "$INSTALL_PATH"
$SUDO_CMD chmod +x "$INSTALL_PATH"

# Nettoyer
rm -rf "$TEMP_DIR"

# Vérification finale
echo
echo "Vérification de l'installation..."
if command -v packager &> /dev/null; then
    INSTALLED_VERSION=$(packager --version)
    echo -e "${GREEN}✓ Installation réussie !${NC}"
    echo -e "${GREEN}Version installée: $INSTALLED_VERSION${NC}"
    echo
    echo "Vous pouvez maintenant utiliser la commande 'packager' depuis n'importe où."
else
    echo -e "${RED}Erreur: La commande 'packager' n'est pas trouvée dans le PATH${NC}"
    echo "Assurez-vous que $INSTALL_DIR est dans votre PATH:"
    echo "  export PATH=\"\$PATH:$INSTALL_DIR\""
    exit 1
fi

echo
echo -e "${GREEN}Installation terminée avec succès !${NC}"

