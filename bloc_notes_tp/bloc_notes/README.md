# 📓 Bloc-Notes — Application Flutter

Application mobile Bloc-Notes développée dans le cadre d'un TP Flutter.  
Permet de créer, lire, modifier et supprimer des notes personnelles avec gestion d'état via **Provider**.

## Fonctionnalités

- ✅ Créer / modifier / supprimer des notes
- 🎨 Choisir une couleur pour chaque note (6 couleurs disponibles)
- 🔍 Recherche en temps réel par titre ou contenu
- 🔤 Tri : par date (récent/ancien) ou par titre (A→Z / Z→A)
- 🔢 Compteur de notes réactif dans l'AppBar

## Stack

- Flutter 3.x
- Provider ^6.1.2
- intl ^0.19.0

## Lancer le projet

```bash
flutter pub get
flutter run
```

## Architecture

```
lib/
├── main.dart                  # Injection Provider
├── models/note.dart           # Modèle de données
├── services/note_service.dart # Logique métier (ChangeNotifier)
└── pages/
    ├── home_page.dart         # Liste + recherche + tri
    ├── create_page.dart       # Formulaire création/modification
    └── detail_page.dart       # Détail + suppression
```

## Rapport

Le rapport complet du TP est disponible dans [`rapport/rapport_tp_flutter.md`](rapport/rapport_tp_flutter.md).
