// lib/models/note.dart

class Note {
  final String id;
  final String titre;
  final String contenu;
  final String couleur;
  final DateTime dateCreation;
  final DateTime? dateModification;

  Note({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.couleur,
    required this.dateCreation,
    this.dateModification,
  });

  /// Crée une copie de la note avec les champs modifiés
  Note copyWith({
    String? titre,
    String? contenu,
    String? couleur,
    DateTime? dateModification,
  }) {
    return Note(
      id: id,
      titre: titre ?? this.titre,
      contenu: contenu ?? this.contenu,
      couleur: couleur ?? this.couleur,
      dateCreation: dateCreation,
      dateModification: dateModification ?? this.dateModification,
    );
  }

  @override
  String toString() =>
      'Note(id: $id, titre: $titre, dateCreation: $dateCreation)';
}
