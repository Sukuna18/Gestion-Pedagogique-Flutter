import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ListeCours extends StatefulWidget {
  const ListeCours({super.key});

  @override
  State<ListeCours> createState() => _ListeCoursState();
}

class _ListeCoursState extends State<ListeCours> {
  Map<String, dynamic> data = {};
  List<dynamic> courses = [];
  Future<void> getCours() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/cours'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {

      data = jsonDecode(response.body);
      courses = data['data'];
      // ignore: avoid_print
      print(courses);
    } else {
      throw Exception('Failed to load cours');
    }
  }

  @override
  void initState() {
    super.initState();
    getCours();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Liste des cours',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Center(child: Text('Liste des cours')),
              backgroundColor: Colors.pink.shade600,
            ),
            body: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
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
                ),
                body: ListView.builder(
                  itemCount: courses.length, 
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            title:
                               const Text('Professeur'),
                            subtitle: Text(course['professeur']['name']),
                            leading: const Icon(Icons.person),
                          ),
                           ListTile(
                            title:
                                const Text('Module'),
                            subtitle: Text(course['module']['libelle']),
                            leading: const Icon(Icons.book),
                          ),
                          ListTile(
                            title:
                                const Text('Classe'),
                            subtitle: Text(course['classe']['libelle']),
                            leading: const Icon(Icons.school),
                          ),
                          ListTile(
                            title:
                                const Text('Semestre'),
                            subtitle: Text(course['semestre']['libelle']),
                            leading: const Icon(Icons.calendar_today),
                          ),
                          ListTile(
                            title:
                                const Text('Heure globale'),
                            subtitle: Text(course['heure_globale'].toString()),
                            leading: const Icon(Icons.timer),
                          ),
                        ],
                      ),
                    );
                  },
                ))));
  }
}
