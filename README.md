# 🔧 tunables.lua – Auto-Updater pour Stand Lua (GTA V)

Un script Lua pour le mod menu **Stand** sur GTA V, permettant de :
- Mettre automatiquement à jour le fichier `tunables.lua` depuis un dépôt GitHub.
- Gérer des réglages personnalisés (langue, notifications...).
- Appliquer des modifications aux globals/tunables de GTA Online.
- Ajouter des fonctionnalités spécifiques à certains événements ou missions.

## 📁 Structure du projet

```
tunables-update/
├── tunables.lua          # Script principal utilisé dans Stand
├── version.txt           # Fichier texte contenant le numéro de version actuel
└── README.md             # Ce fichier
```

## 🚀 Fonctionnalités principales

- ✅ Vérification automatique de la version actuelle.
- ⬇️ Téléchargement et mise à jour silencieuse depuis GitHub.
- 📦 Gestion des fichiers de configuration (`Setting.txt`, `Log.txt`, etc.).
- 🌐 Support multilingue (anglais, français…).
- 📸 Affichage d'images intégrées dans Stand (ex: logo, bannières).
- 🧠 Manipulation des globals (avec `SET_INT_GLOBAL`, `SET_FLOAT_GLOBAL`, etc).
- 🧪 Fonctions diverses : téléportation, chargement de scripts, notification personnalisée.

## 🔧 Prérequis

- Avoir **Stand Mod Menu** installé sur GTA V.
- Accéder à **Stand > Lua Scripts**.
- **Activer l’accès Internet** pour les scripts Lua :
  ```
  Stand > Settings > Lua Scripts > Allow Internet Access (à cocher)
  ```

## 📥 Installation

1. Va dans : `%appdata%\Stand\Lua Scripts`
2. Crée un dossier par exemple `Liberty City`
3. Glisse `tunables.lua` et `version.txt` dedans.
4. Lance GTA V et charge le script depuis **Stand > Lua Scripts > Liberty City > tunables.lua**

## 🔄 Mise à jour automatique

Le script vérifie à chaque exécution si une version plus récente est disponible :
- Si oui, il télécharge `tunables.lua` depuis ce repo.
- Sinon, il affiche un toast `[Update] Déjà à jour.`

⚠️ Si tu vois l'erreur :
```
[Update] Erreur : internet.request_async non dispo.
```
Assure-toi que l’accès Internet est activé dans les options de Stand.

## 🌐 Fichier de langue

Tu peux créer ou modifier des fichiers dans :
```
%AppData%\Stand\Lua Scripts\store\Liberty City\Language\
```

## 💡 Développeur

Créé par [BleuDragonViolet](https://github.com/BleuDragonViolet) [Affmal](https://github.com/affmalmodz)

---

## 📜 Licence

Ce script est distribué gratuitement. Tu peux le modifier ou le réutiliser tant que tu crédite l’auteur original.
