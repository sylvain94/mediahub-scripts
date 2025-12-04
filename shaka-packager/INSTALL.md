# Installation de Shaka Packager

Ce guide présente plusieurs méthodes pour installer Shaka Packager sur Linux.

## Installation automatique (recommandée)

Un script d'installation automatique est disponible :

```bash
chmod +x install.sh
sudo ./install.sh
```

Le script télécharge la dernière version précompilée et l'installe dans `/usr/local/bin`.

### Résultat final avec le script mbts_to_hls

service01/
├── 480p
│   ├── service01_01.ts
│   ├── service01_02.ts
│   └── service01_03.ts
├── 480p.m3u8
├── 720p
│   ├── service01_01.ts
│   ├── service01_02.ts
│   └── service01_03.ts
├── 720p.m3u8
└── master.m3u8

## Liens utiles

- [Releases officielles](https://github.com/shaka-project/shaka-packager/releases)
- [Documentation officielle](https://shaka-project.github.io/shaka-packager/html/tutorials/tutorials.html)
- [Dépôt GitHub](https://github.com/shaka-project/shaka-packager)
