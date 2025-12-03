# Installation de Shaka Packager

Ce guide présente plusieurs méthodes pour installer Shaka Packager sur Linux.

## Méthode 1 : Installation automatique (recommandée)

Un script d'installation automatique est disponible :

```bash
chmod +x install.sh
sudo ./install.sh
```

Le script télécharge la dernière version précompilée et l'installe dans `/usr/local/bin`.

## Méthode 2 : Installation manuelle avec binaire précompilé

### Étape 1 : Télécharger la dernière version

```bash
# Récupérer la dernière version depuis GitHub
LATEST_VERSION=$(curl -s https://api.github.com/repos/shaka-project/shaka-packager/releases/latest | grep "tag_name" | cut -d '"' -f 4)
echo "Dernière version : $LATEST_VERSION"

# Télécharger le binaire Linux (64-bit)
cd /tmp
wget "https://github.com/shaka-project/shaka-packager/releases/download/${LATEST_VERSION}/packager-linux-x64"
```

### Étape 2 : Installer le binaire

```bash
# Rendre exécutable
chmod +x packager-linux-x64

# Déplacer vers un répertoire dans le PATH
sudo mv packager-linux-x64 /usr/local/bin/packager

# Vérifier l'installation
packager --version
```

## Méthode 3 : Installation via Docker

Si Docker est installé sur votre système :

```bash
# Créer un alias pour faciliter l'utilisation
echo 'alias packager="docker run --rm -v $(pwd):/workdir -w /workdir google/shaka-packager"' >> ~/.bashrc
source ~/.bashrc

# Utilisation
packager --version
```

**Note** : Avec Docker, vous devrez adapter les commandes pour mapper les volumes et les ports réseau nécessaires.

## Méthode 4 : Compilation depuis les sources

### Prérequis

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y git python3 ninja-build

# Installer depot_tools (nécessaire pour gclient)
cd /tmp
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH="$PATH:/tmp/depot_tools"
```

### Compilation

```bash
# Cloner le dépôt
git clone https://github.com/shaka-project/shaka-packager.git
cd shaka-packager

# Récupérer les dépendances
gclient config https://www.github.com/shaka-project/shaka-packager.git --name=src --unmanaged
gclient sync

# Compiler
cd src
ninja -C out/Release packager

# Installer
sudo cp out/Release/packager /usr/local/bin/
```

## Vérification de l'installation

Après l'installation, vérifiez que tout fonctionne :

```bash
packager --version
```

Vous devriez voir quelque chose comme :
```
packager version v2.x.x
```

## Dépannage

### Le binaire n'est pas trouvé

Vérifiez que `/usr/local/bin` est dans votre PATH :

```bash
echo $PATH | grep /usr/local/bin
```

Si ce n'est pas le cas, ajoutez-le :

```bash
echo 'export PATH="$PATH:/usr/local/bin"' >> ~/.bashrc
source ~/.bashrc
```

### Permission refusée

Assurez-vous que le binaire est exécutable :

```bash
chmod +x /usr/local/bin/packager
```

### Version 32-bit

Si vous êtes sur un système 32-bit, utilisez `packager-linux` au lieu de `packager-linux-x64` dans les URLs de téléchargement.

## Liens utiles

- [Releases officielles](https://github.com/shaka-project/shaka-packager/releases)
- [Documentation officielle](https://shaka-project.github.io/shaka-packager/html/tutorials/tutorials.html)
- [Dépôt GitHub](https://github.com/shaka-project/shaka-packager)

