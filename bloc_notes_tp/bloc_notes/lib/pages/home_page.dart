// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';
import '../services/note_service.dart';
import 'create_page.dart';
import 'detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // ── Couleur hex → Color ──────────────────────────────────────────────────
  Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  // ── Navigation ───────────────────────────────────────────────────────────
  Future<void> _openCreate(BuildContext context) async {
    final note = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => const CreateNotePage()),
    );
    if (note != null && context.mounted) {
      context.read<NoteService>().addNote(note);
    }
  }

  Future<void> _openDetail(BuildContext context, Note note) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (_) => DetailNotePage(note: note)),
    );
    if (!context.mounted) return;
    if (result is Note) {
      context.read<NoteService>().updateNote(result);
    } else if (result == 'deleted') {
      context.read<NoteService>().deleteNote(note.id);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return _HomePageContent(
      hexToColor: _hexToColor,
      onOpenCreate: _openCreate,
      onOpenDetail: _openDetail,
    );
  }
}

/// Widget interne avec état local pour la recherche
class _HomePageContent extends StatefulWidget {
  final Color Function(String) hexToColor;
  final Future<void> Function(BuildContext) onOpenCreate;
  final Future<void> Function(BuildContext, Note) onOpenDetail;

  const _HomePageContent({
    required this.hexToColor,
    required this.onOpenCreate,
    required this.onOpenDetail,
  });

  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent> {
  String _query = '';
  bool _searchVisible = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<NoteService>();
    final notes =
        _query.isEmpty ? service.notes : service.search(_query);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: _searchVisible
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Rechercher une note…',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (v) => setState(() => _query = v),
              )
            : Row(
                children: [
                  const Text('Mes Notes',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  // Compteur en temps réel — Consumer ciblé
                  Consumer<NoteService>(
                    builder: (_, svc, __) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('${svc.count}',
                          style: const TextStyle(fontSize: 13)),
                    ),
                  ),
                ],
              ),
        actions: [
          // Bouton recherche
          IconButton(
            icon: Icon(_searchVisible ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _searchVisible = !_searchVisible;
                if (!_searchVisible) {
                  _query = '';
                  _searchController.clear();
                }
              });
            },
          ),
          // Menu tri
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            tooltip: 'Trier',
            onSelected: (opt) => context.read<NoteService>().setSortOption(opt),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: SortOption.dateDesc,
                child: Text('📅 Récent d\'abord'),
              ),
              PopupMenuItem(
                value: SortOption.dateAsc,
                child: Text('📅 Ancien d\'abord'),
              ),
              PopupMenuItem(
                value: SortOption.titreAZ,
                child: Text('🔤 Titre A → Z'),
              ),
              PopupMenuItem(
                value: SortOption.titreZA,
                child: Text('🔤 Titre Z → A'),
              ),
            ],
          ),
        ],
      ),
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _query.isNotEmpty
                        ? Icons.search_off
                        : Icons.note_alt_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _query.isNotEmpty
                        ? 'Aucun résultat pour "$_query"'
                        : 'Aucune note',
                    style: TextStyle(
                        fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final noteColor = widget.hexToColor(note.couleur);
                final preview = note.contenu.length > 30
                    ? '${note.contenu.substring(0, 30)}…'
                    : note.contenu;
                final dateStr = DateFormat('dd/MM/yyyy').format(note.dateCreation);

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () =>
                        widget.onOpenDetail(context, note),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border(
                          left: BorderSide(color: noteColor, width: 5),
                        ),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note.titre,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (preview.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    preview,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600]),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            dateStr,
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        onPressed: () => widget.onOpenCreate(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
