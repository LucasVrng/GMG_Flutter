# GMG — Free Games Catalog

App mobile Flutter qui permet de parcourir, chercher et découvrir des jeux **free-to-play** sur PC et navigateur. Les données viennent en direct de l'API publique [FreeToGame](https://www.freetogame.com/api-doc).

Projet réalisé dans le cadre du module **Développement d'applications mobiles** (Bachelor 2 Informatique — S2 2025/2026).

---

## Fonctionnalités

- **Accueil** : grille de tous les jeux gratuits dispo, avec image, titre, genre.
- **Recherche** : liste filtrable par genre (MMORPG, Shooter, MOBA, Battle Royale, etc.) via un menu déroulant.
- **Random** : un jeu tiré au hasard à chaque appui sur le bouton dé, pour la découverte.
- **Détails** : fiche complète d'un jeu (description, plateforme, éditeur, dev, date de sortie, config minimale, screenshots).
- Navigation par **bottom nav bar** entre les 3 écrans principaux + **push** vers la page détails avec passage de l'id.
- Gestion propre des 3 états réseau : **loading / error / data** avec bouton "Réessayer".

## Stack

- **Flutter** (SDK ^3.11.4)
- **Dart**
- Package `http` pour les appels API
- `setState` pour la gestion d'état (pas de Provider/BLoC, on a gardé simple)
- Material Design

## API utilisée

[FreeToGame API](https://www.freetogame.com/api-doc) — base de données de plus de **400 jeux free-to-play**, gratuite, sans authentification, sans clé, libre pour usage perso et commercial.

> Données fournies par [FreeToGame.com](https://www.freetogame.com) — attribution obligatoire selon les conditions d'utilisation de l'API.

Base URL : `https://www.freetogame.com/api`

Endpoints qu'on utilise dans l'app :
- `GET /games` → liste de tous les jeux (page d'accueil)
- `GET /games?category=<genre>` → filtrage par genre, ex. `mmorpg`, `shooter`, `moba` (page recherche)
- `GET /game?id=<id>` → détails complets d'un jeu (page détails et page random, après tirage d'un id au hasard)

L'API expose aussi d'autres endpoints non utilisés ici (`?platform=`, `?sort-by=`, `/filter?tag=`), qui pourraient servir pour des évolutions futures.

**Limite** : pas plus de 10 requêtes/seconde — large dans notre cas, on ne déclenche un appel que sur action utilisateur.

**Codes de réponse** gérés :
- `200` → données récupérées, on parse le JSON
- `404` / `500` → on tombe dans le bloc d'erreur du `FutureBuilder` qui affiche le message + bouton "Réessayer"

## Lancer le projet

Pré-requis :
- Flutter SDK installé ([guide officiel](https://docs.flutter.dev/get-started/install))
- Un émulateur Android lancé OU un device branché en USB avec le mode dev activé

```bash
# Cloner le repo
git clone https://github.com/LucasVrng/GMG_Flutter.git
cd GMG_Flutter

# Installer les dépendances
flutter pub get

# Lancer l'app
flutter run
```

## Structure du projet

```
lib/
├── main.dart                  # Point d'entrée, MaterialApp + routes
├── main_screen.dart           # Wrapper avec bottom nav bar
├── widgets/
│   └── navbar.dart            # Bottom navigation bar
├── home/
│   └── screen/                # Page d'accueil + carte de jeu
├── search/
│   ├── models/                # Modèle Game (version search)
│   ├── screen/                # Écran de recherche/filtre
│   └── services/              # Appel API + parsing
├── random/
│   ├── models/
│   ├── screen/                # Écran random
│   └── services/
└── details/
    ├── models/                # Modèle Game complet (avec config min, screenshots)
    ├── screen/                # Écran détail
    └── services/
```

Chaque feature suit le même pattern : `models/` (data classes), `screen/` (UI), `services/` (appels HTTP).

## Dépendances

Voir [pubspec.yaml](pubspec.yaml) :
- `flutter`
- `cupertino_icons: ^1.0.8`
- `http: ^1.6.0`

## Auteurs

Projet de groupe — voir l'historique des commits sur le [dépôt GitHub](https://github.com/LucasVrng/GMG_Flutter).

## Documentation

- [JUSTIFICATION.md](JUSTIFICATION.md) — note de justification technique (choix d'architecture, d'API, difficultés rencontrées)

## Crédits

Données : [FreeToGame.com](https://www.freetogame.com) — base de données publique des jeux free-to-play.
