// lib/services/note_service.dart

import 'package:flutter/foundation.dart';
import '../models/note.dart';

enum SortOption {
  dateDesc,   // récent d'abord (défaut)
  dateAsc,    // ancien d'abord
  titreAZ,    // alphabétique A → Z
  titreZA,    // alphabétique Z → A
}

class NoteService extends ChangeNotifier {
  final List<Note> _notes = [];
  SortOption _sortOption = SortOption.dateDesc;

  // ── Getters ──────────────────────────────────────────────────────────────

  /// Retourne une liste non-modifiable triée selon l'option courante
  List<Note> get notes {
    final sorted = List<Note>.from(_notes);
    switch (_sortOption) {
      case SortOption.dateDesc:
        sorted.sort((a, b) => b.dateCreation.compareTo(a.dateCreation));
      case SortOption.dateAsc:
        sorted.sort((a, b) => a.dateCreation.compareTo(b.dateCreation));
      case SortOption.titreAZ:
        sorted.sort((a, b) => a.titre.compareTo(b.titre));
      case SortOption.titreZA:
        sorted.sort((a, b) => b.titre.compareTo(a.titre));
    }
    return List.unmodifiable(sorted);
  }

  int get count => _notes.length;

  SortOption get sortOption => _sortOption;

  // ── CRUD ──────────────────────────────────────────────────────────────────

  void addNote(Note note) {
    _notes.insert(0, note);
    notifyListeners();
  }

  void updateNote(Note note) {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  Note? getNoteById(String id) {
    try {
      return _notes.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Recherche ─────────────────────────────────────────────────────────────

  /// Filtre les notes par titre ou contenu (insensible à la casse)
  List<Note> search(String query) {
    if (query.isEmpty) return notes;
    final q = query.toLowerCase();
    return notes
        .where((n) =>
            n.titre.toLowerCase().contains(q) ||
            n.contenu.toLowerCase().contains(q))
        .toList();
  }

  // ── Tri ───────────────────────────────────────────────────────────────────

  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }
}
