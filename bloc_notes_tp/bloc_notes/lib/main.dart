// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'services/note_service.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialise la locale française pour les dates
  await initializeDateFormatting('fr_FR', null);
  runApp(const BlocNotesApp());
}

class BlocNotesApp extends StatelessWidget {
  const BlocNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoteService(),
      child: MaterialApp(
        title: 'Bloc-Notes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const HomePage(),
      ),
    );
  }
}
