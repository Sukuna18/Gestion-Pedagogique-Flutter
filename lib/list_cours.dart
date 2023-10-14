import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListeCours extends StatefulWidget {
  const ListeCours({super.key});

  @override
  State<ListeCours> createState() => _ListeCoursState();
}

class _ListeCoursState extends State<ListeCours> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liste des cours',
      home: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('Liste des cours')),
            backgroundColor: Colors.pink.shade600,
          ),
          body: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  actions: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('token');
          if (context.mounted) context.go('/');
        },
        icon: Icon(
          Icons.exit_to_app,
          color: Colors.pink.shade600,
          size: 40, 
        ),
      ),
    ),
  ],
)
      )
    );
  }
}
