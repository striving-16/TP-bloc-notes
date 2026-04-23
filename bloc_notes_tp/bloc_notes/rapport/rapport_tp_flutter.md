# Rapport de TP — Application Bloc-Notes Flutter

**Module :** Développement Mobile Flutter  
**Sujet :** Application Bloc-Notes — setState, Navigation & Provider  
**Date :** Avril 2026

---

## 1. Introduction

Ce TP avait pour objectif de concevoir et développer une application mobile **Bloc-Notes** complète en Flutter. L'application permet à l'utilisateur de créer, lire, modifier et supprimer des notes personnelles. Chaque note possède un titre, un contenu, une couleur personnalisable et une date de création.

Le travail est organisé en deux parties progressives :
- **Partie 1** : gestion de l'état avec `setState` et navigation entre 4 écrans
- **Partie 2** : refactorisation de l'architecture avec le pattern **Provider**

---

## 2. Architecture du projet

```
bloc_notes/
├── lib/
│   ├── main.dart               # Point d'entrée, injection Provider
│   ├── models/
│   │   └── note.dart           # Modèle de données Note
│   ├── services/
│   │   └── note_service.dart   # Logique métier (ChangeNotifier)
│   └── pages/
│       ├── home_page.dart      # Liste des notes + recherche + tri
│       ├── create_page.dart    # Formulaire création / modification
│       └── detail_page.dart    # Affichage détail + suppression
├── pubspec.yaml
└── .gitignore
```

---

## 3. Partie 1 — setState & Navigation

### 3.1 Modèle de données (`Note`)

La classe `Note` (dans `lib/models/note.dart`) représente une note avec les champs suivants :

| Attribut | Type | Description |
|---|---|---|
| `id` | `String` | Identifiant unique (timestamp en millisecondes) |
| `titre` | `String` | Titre de la note (max 60 caractères) |
| `contenu` | `String` | Corps de la note |
| `couleur` | `String` | Code couleur hexadécimal (ex : `#FFE082`) |
| `dateCreation` | `DateTime` | Date et heure de création |
| `dateModification` | `DateTime?` | Date de dernière modification (optionnel) |

Un constructeur `copyWith` permet de créer une copie modifiée de la note sans muter l'original, en accord avec les bonnes pratiques d'immutabilité en Dart.

### 3.2 Page d'accueil (`HomePage`)

La `HomePage` affiche la liste de toutes les notes sous forme de cartes (`ListView.builder`). Chaque carte montre le titre, les 30 premiers caractères du contenu, la date de création, et un bandeau coloré sur le bord gauche correspondant à la couleur de la note.

Un `FloatingActionButton` avec l'icône `+` permet d'accéder à la page de création.

### 3.3 Formulaire de création / modification (`CreateNotePage`)

Cette page sert à la fois pour créer et modifier une note. Elle accepte un paramètre optionnel `Note? note` :
- Si `note == null` → mode création
- Si `note != null` → mode modification, les champs sont pré-remplis dans `initState`

Le formulaire contient :
- Un `TextField` pour le titre (limite à 60 caractères avec `maxLength`)
- Un `TextField` multilignes pour le contenu (`minLines: 4, maxLines: 10`)
- Un sélecteur de couleur : 6 cercles colorés cliquables avec animation (`AnimatedContainer`)
- Une validation : le titre ne peut pas être vide

À la sauvegarde, la note est retournée à l'écran précédent via `Navigator.pop(context, note)`.

### 3.4 Page de détail (`DetailNotePage`)

Cette page reçoit un objet `Note` et affiche :
- Le titre en grand (fontSize 24, bold)
- La date de création formatée en français (ex : "18 avril 2026 à 14:30")
- La date de modification si elle existe
- Le contenu complet dans un champ scrollable
- L'AppBar colorée avec la couleur de la note

Elle propose deux actions dans l'AppBar :
- **Modifier** → navigue vers `CreateNotePage` en passant la note, puis retourne la note modifiée
- **Supprimer** → ouvre un `AlertDialog` de confirmation, puis retourne `'deleted'` à la `HomePage`

### 3.5 Boucle CRUD complète

La `HomePage` gère les résultats de navigation comme suit :

| Action | Résultat reçu | Effet sur l'état |
|---|---|---|
| Créer | Objet `Note` | `_notes.add(note)` |
| Modifier | Objet `Note` | `_notes[index] = note` |
| Supprimer | `'deleted'` | `_notes.removeAt(index)` |

---

## 4. Partie 2 — Provider & Gestion d'État Global

### 4.1 NoteService (`ChangeNotifier`)

`NoteService` est le cœur de l'architecture Provider. Il encapsule toutes les données et la logique métier, séparées de l'interface :

| Méthode / Propriété | Rôle | `notifyListeners` |
|---|---|---|
| `List<Note> get notes` | Retourne une liste triée non-modifiable | Non |
| `int get count` | Nombre total de notes | Non |
| `addNote(Note)` | Ajoute une note | Oui |
| `updateNote(Note)` | Remplace la note avec le même `id` | Oui |
| `deleteNote(String)` | Supprime par `id` | Oui |
| `getNoteById(String)` | Retourne une note ou `null` | Non |
| `search(String)` | Filtre par titre ou contenu | Non |
| `setSortOption(SortOption)` | Change le critère de tri | Oui |

### 4.2 Injection dans `main.dart`

Le `NoteService` est injecté une seule fois au sommet de l'arbre de widgets avec `ChangeNotifierProvider`, rendant le service accessible à tous les widgets enfants :

```dart
ChangeNotifierProvider(
  create: (_) => NoteService(),
  child: MaterialApp(...),
)
```

### 4.3 Refactorisation de `HomePage`

Après la Partie 2, la `HomePage` ne maintient plus de liste locale. Elle consomme directement le `NoteService` :

| Avant (setState) | Après (Provider) |
|---|---|
| `List<Note> _notes = []` | `context.watch<NoteService>().notes` |
| `setState(() { _notes.add(note); })` | `context.read<NoteService>().addNote(note)` |
| `setState(() { _notes[i] = note; })` | `context.read<NoteService>().updateNote(note)` |
| `setState(() { _notes.removeAt(i); })` | `context.read<NoteService>().deleteNote(id)` |

La distinction entre `context.watch<T>()` (utilisé dans `build` pour s'abonner aux changements) et `context.read<T>()` (utilisé dans les callbacks pour appeler des méthodes) est respectée.

---

## 5. Fonctionnalités avancées (EX.6)

### 5.1 Barre de recherche

Une barre de recherche est intégrée dans l'`AppBar`. Elle filtre les notes en temps réel par titre ou contenu. L'état local `_query` est géré avec `setState` uniquement pour cette variable, tandis que la liste affichée provient de `noteService.search(_query)`. Un message "Aucun résultat" s'affiche si la recherche ne trouve rien.

### 5.2 Tri des notes

Le `NoteService` expose une enum `SortOption` avec 4 options :

| Option | Comportement |
|---|---|
| `dateDesc` | Récent d'abord (défaut) |
| `dateAsc` | Ancien d'abord |
| `titreAZ` | Alphabétique A → Z |
| `titreZA` | Alphabétique Z → A |

Le tri est accessible via un `PopupMenuButton` dans l'`AppBar` de la `HomePage`.

### 5.3 Compteur dans l'AppBar

Le compteur de notes dans l'`AppBar` est encapsulé dans un `Consumer<NoteService>` ciblé. Cela permet de reconstruire uniquement ce widget lorsque le nombre de notes change, sans reconstruire toute la page.

---

## 6. Choix techniques

- **`intl` + `initializeDateFormatting`** : utilisé pour formater les dates en français dans la page de détail.
- **`uuid` (via timestamp)** : l'identifiant unique de chaque note est le timestamp en millisecondes, simple et suffisant pour ce TP.
- **Immutabilité des listes** : `NoteService.notes` retourne `List.unmodifiable(...)` pour éviter toute mutation accidentelle depuis l'interface.
- **`AnimatedContainer`** dans le sélecteur de couleur : améliore l'expérience utilisateur avec une transition fluide lors du changement de couleur sélectionnée.
- **Luminance adaptative** : dans `DetailNotePage`, la couleur du texte de l'`AppBar` est calculée automatiquement selon la luminosité de la couleur de la note pour garantir la lisibilité.

---

## 7. Conclusion

Ce TP a permis de mettre en pratique deux approches complémentaires de gestion d'état en Flutter. La Partie 1 avec `setState` illustre la gestion locale et le passage de données entre écrans via `Navigator`. La Partie 2 avec Provider démontre comment extraire la logique métier dans un service dédié, permettant à plusieurs écrans de partager un état global sans couplage direct.

L'application finale est fonctionnelle, bien structurée, et implémente toutes les fonctionnalités demandées : CRUD complet, recherche temps réel, tri configurable et compteur réactif.
