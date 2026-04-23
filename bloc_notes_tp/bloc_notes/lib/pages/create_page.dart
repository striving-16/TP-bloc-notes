// lib/pages/create_page.dart

import 'package:flutter/material.dart';
import '../models/note.dart';

class CreateNotePage extends StatefulWidget {
  /// Si une note est fournie, on est en mode modification
  final Note? note;

  const CreateNotePage({super.key, this.note});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  late final TextEditingController _titreController;
  late final TextEditingController _contenuController;
  late String _couleurSelectionnee;

  // Palette de 6 couleurs disponibles
  static const List<String> _couleurs = [
    '#FFE082', // Jaune
    '#EF9A9A', // Rouge
    '#A5D6A7', // Vert
    '#90CAF9', // Bleu
    '#CE93D8', // Violet
    '#FFAB91', // Orange
  ];

  bool get _isModification => widget.note != null;

  @override
  void initState() {
    super.initState();
    // Pré-remplir si modification
    _titreController =
        TextEditingController(text: widget.note?.titre ?? '');
    _contenuController =
        TextEditingController(text: widget.note?.contenu ?? '');
    _couleurSelectionnee = widget.note?.couleur ?? _couleurs[0];
  }

  @override
  void dispose() {
    _titreController.dispose();
    _contenuController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  void _sauvegarder() {
    if (_titreController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le titre ne peut pas être vide.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final now = DateTime.now();

    late Note note;
    if (_isModification) {
      note = widget.note!.copyWith(
        titre: _titreController.text.trim(),
        contenu: _contenuController.text.trim(),
        couleur: _couleurSelectionnee,
        dateModification: now,
      );
    } else {
      note = Note(
        id: now.millisecondsSinceEpoch.toString(),
        titre: _titreController.text.trim(),
        contenu: _contenuController.text.trim(),
        couleur: _couleurSelectionnee,
        dateCreation: now,
      );
    }

    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title:
            Text(_isModification ? 'Modifier la note' : 'Nouvelle Note'),
        actions: [
          TextButton.icon(
            onPressed: _sauvegarder,
            icon: const Icon(Icons.check, color: Colors.white),
            label: const Text('Sauvegarder',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Titre ──────────────────────────────────────────────────────
            TextField(
              controller: _titreController,
              maxLength: 60,
              decoration: InputDecoration(
                labelText: 'Titre de la note',
                prefixIcon: const Icon(Icons.title),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // ── Contenu ────────────────────────────────────────────────────
            TextField(
              controller: _contenuController,
              minLines: 4,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: 'Contenu',
                alignLabelWithHint: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Icon(Icons.notes),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),

            // ── Sélecteur couleur ──────────────────────────────────────────
            const Text(
              'Couleur',
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _couleurs.map((hex) {
                final isSelected = hex == _couleurSelectionnee;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _couleurSelectionnee = hex),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isSelected ? 46 : 38,
                    height: isSelected ? 46 : 38,
                    decoration: BoxDecoration(
                      color: _hexToColor(hex),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Colors.deepPurple
                            : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.deepPurple.withOpacity(0.4),
                                blurRadius: 6,
                              )
                            ]
                          : [],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check,
                            size: 18, color: Colors.deepPurple)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
