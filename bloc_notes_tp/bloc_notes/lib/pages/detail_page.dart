// lib/pages/detail_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import 'create_page.dart';

class DetailNotePage extends StatelessWidget {
  final Note note;

  const DetailNotePage({super.key, required this.note});

  Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  String _formatDate(DateTime dt) {
    return DateFormat("d MMMM yyyy 'à' HH:mm", 'fr_FR').format(dt);
  }

  Future<void> _modifier(BuildContext context) async {
    final updated = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => CreateNotePage(note: note)),
    );
    if (updated != null && context.mounted) {
      Navigator.pop(context, updated);
    }
  }

  void _confirmerSuppression(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la note'),
        content: const Text(
            'Voulez-vous vraiment supprimer cette note ? Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx); // ferme le dialog
              Navigator.pop(context, 'deleted'); // retourne à HomePage
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteColor = _hexToColor(note.couleur);
    // Choisir une couleur de texte lisible selon la luminosité
    final onNoteColor =
        noteColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: noteColor,
        foregroundColor: onNoteColor,
        title: Text(
          note.titre,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: onNoteColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        iconTheme: IconThemeData(color: onNoteColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Modifier',
            onPressed: () => _modifier(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Supprimer',
            onPressed: () => _confirmerSuppression(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Titre ──────────────────────────────────────────────────────
            Text(
              note.titre,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // ── Date(s) ────────────────────────────────────────────────────
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Créée le ${_formatDate(note.dateCreation)}',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            if (note.dateModification != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.edit_calendar,
                      size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    'Modifiée le ${_formatDate(note.dateModification!)}',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),

            // ── Contenu ────────────────────────────────────────────────────
            Text(
              note.contenu.isEmpty ? '(aucun contenu)' : note.contenu,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: note.contenu.isEmpty
                    ? Colors.grey[400]
                    : Colors.black87,
                fontStyle: note.contenu.isEmpty
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
