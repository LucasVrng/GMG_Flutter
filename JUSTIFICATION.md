# Note de justification technique — GMG

## 1. Le problème que résout l'app

Quand on cherche un jeu gratuit à essayer, on tombe vite sur des sites bourrés de pubs ou des listes pas à jour. Notre app **GMG** centralise les jeux free-to-play du moment dans une interface simple : on parcourt, on filtre par genre, et si on a la flemme de choisir, on tire un jeu au hasard. C'est une app de **découverte de jeux gratuits**, pensée mobile.

## 2. Choix techniques

### Architecture du code

On a découpé le projet **par feature** plutôt que par type de fichier. Chaque écran (home, search, random, details) a son propre dossier qui contient :
- `models/` → les classes de données (parsing JSON)
- `screen/` → l'UI Flutter
- `services/` → les appels HTTP

Pourquoi ce choix : c'est plus lisible quand on veut bosser sur une feature, on a tout au même endroit. Quand on bossait à plusieurs, ça permettait à chacun de modifier sa partie sans marcher sur les autres (moins de conflits Git).

Pour la **gestion d'état**, on est restés sur `setState` + `FutureBuilder`. On a hésité avec Provider mais comme l'app a peu d'état partagé entre écrans (chaque écran refetch ses données), c'était de la complexité pour rien. Les consignes disaient explicitement que `setState` bien utilisé suffit.

La **navigation** combine deux trucs :
- Une `BottomNavigationBar` pour switcher entre les 3 écrans principaux (via `IndexedStack`-like avec une `List<Widget>`).
- Un `Navigator.push` classique vers `DetailsScreen` quand on tape sur un jeu, avec passage de l'`id` en argument.

### API choisie

On a pris **[FreeToGame](https://www.freetogame.com/api-doc)** (base URL `https://www.freetogame.com/api`).

Pourquoi elle :
- **Pas d'authentification du tout** → aucune clé à gérer, pas de risque que la clé soit révoquée pendant la soutenance, et rien de sensible à cacher dans le repo.
- **400+ jeux free-to-play** dans la base, c'est largement suffisant pour avoir du contenu réel et pas une démo vide.
- **Rate limit confortable** : 10 requêtes/seconde, on n'est jamais proche de la saturation puisqu'on n'appelle l'API que quand l'utilisateur fait une action.
- **Données riches sur l'endpoint `/game?id=`** : titre, genre, plateforme, description longue, date de sortie, éditeur, dev, **screenshots** et **config minimale** (OS, CPU, RAM, GPU, stockage). Ça nourrit largement la page détails.
- **Filtrage natif** côté serveur via `?category=<genre>`, donc on délègue le filtre à l'API au lieu de tout charger et filtrer côté client.
- **Libre pour usage perso et commercial**, condition unique : citer FreeToGame.com comme source (ce qu'on fait dans le README).

On avait regardé RAWG (plus complet mais clé API requise) et IGDB (auth Twitch obligatoire, trop chiant à gérer pour un projet de 2 semaines). FreeToGame était le meilleur compromis : zéro friction de mise en place, données suffisantes, et le scope (uniquement free-to-play) colle pile au thème de notre app.

### Limites connues de l'API

On a eu conscience de quelques limites en bossant avec FreeToGame :
- **Catalogue restreint au free-to-play PC / navigateur** : pas de jeux payants, pas de console (PS, Xbox, Switch). Ça cadre l'app mais ça l'enferme aussi sur ce créneau.
- **Pas d'endpoint de recherche textuelle** (genre `?q=fortnite`). On filtre uniquement par catégorie/plateforme/tag. Si on voulait une vraie barre de recherche par titre, il faudrait charger toute la liste et filtrer côté client.
- **Pas de pagination** : `/games` renvoie d'un coup la liste complète. Sur 400+ jeux ça passe encore, mais sur mobile c'est limite niveau perf, et ça scalerait mal si la base grossissait.
- **Données parfois incomplètes** : certains jeux ont des champs vides (description courte, screenshots), donc côté UI on a dû gérer les cas "champ vide" (cf. le `value.isEmpty ? '—' : value` dans la page random).
- **Pas de garantie de SLA** : c'est une API gratuite communautaire. Si elle tombe le jour de la soutenance, on n'a pas de plan B automatique. Pour mitiger, on a prévu de pouvoir lancer la démo sur émulateur avec une connexion stable et on a testé l'app plusieurs fois en amont.

### Gestion des 3 états

Sur chaque écran qui appelle l'API, on utilise un `FutureBuilder<List<Game>>` qui gère :
- **Loading** → `CircularProgressIndicator` + texte "Chargement…"
- **Error** → icône wifi-off + message "Impossible de charger les jeux" + bouton **Réessayer** qui relance le `Future`
- **Data** → la grille / liste des jeux

Concrètement on regarde `response.statusCode` : si c'est `200` on parse le JSON, sinon on `throw` une `Exception` qui est attrapée par le `FutureBuilder` et bascule sur l'état d'erreur. Ça couvre les cas `404` (jeu/endpoint introuvable) et `500` (erreur serveur) de l'API, ainsi que les cas où le téléphone n'a pas de réseau.

Le bouton "Réessayer" relance simplement la méthode de fetch via `setState`, ce qui force le `FutureBuilder` à refaire l'appel.

## 3. Difficultés rencontrées

- **Conflits Git en pagaille au début**. On bossait tous sur la même branche, et à chaque pull on se mangeait des conflits sur `main.dart` ou les routes. On a réglé ça en **séparant le code par feature** (un dossier par écran) et en bossant sur des **branches dédiées** qu'on mergeait ensuite. Les derniers commits (`merge homepage and details`, `complete merge`) en témoignent.
- **Le passage d'arguments à `DetailsScreen`**. On utilisait au début un endpoint hardcodé pour les détails (toujours le même jeu). On a finalement fait passer l'`id` via `MaterialPageRoute` + paramètre du constructeur, et l'API est appelée à chaque tap (cf. commit `Removed URL model endpoints, OnTap calls everytime to API/ID`).
- **Le parsing JSON imbriqué** côté détails (config minimale, liste de screenshots). On a fait des sous-classes (`MinimumSystemRequirements`, `Screenshot`) avec leur propre `fromJson`, ce qui rend le code plus propre.
- **Charte graphique pas alignée** entre les écrans au départ (chacun avait fait son thème dans son coin). On l'a un peu uniformisée vers une palette type Steam (bleu foncé / texte clair) mais on a pas tout refondu — ça reste un point d'amélioration.

## 4. Avec plus de temps

- **Mettre en place un thème global** (`ThemeData` partagé) pour vraiment unifier les couleurs entre tous les écrans, au lieu de redéfinir des constantes locales partout.
- **Ajouter un système de favoris** stocké localement (`shared_preferences`) pour marquer les jeux qu'on veut tester plus tard.
- **Cache des résultats** pour pas refaire l'appel API à chaque retour sur l'écran (genre `cached_network_image` pour les images, et un cache mémoire simple pour la liste).
- **Tests** — on n'a pas écrit de tests unitaires sur le parsing ni de widget tests, ça serait à ajouter.
- **Passer à Provider ou Riverpod** si l'app grossissait, pour partager l'état entre écrans (favoris, filtres mémorisés, etc.).
