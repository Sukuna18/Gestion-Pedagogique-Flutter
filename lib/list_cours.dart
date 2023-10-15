import 'dart:convert';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
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
  Future<void> logout() async {
    // Afficher une boîte de dialogue de confirmation
    bool confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Confirmation'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?', style: TextStyle(fontSize: 20)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Annuler la déconnexion
              },
              child: const Text('Annuler', style: TextStyle(color: Colors.red, fontSize: 20)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmer la déconnexion
              },
              child: const Text('Déconnexion', style: TextStyle(color: Colors.green, fontSize: 20)),
            ),
          ],
        );
      },
    );

    // Si l'utilisateur a confirmé la déconnexion, alors effectuez la déconnexion
    if (confirmLogout == true) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      if (context.mounted) context.go('/');
    }
  }

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
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.pink.shade100,
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Card(
                      margin: const EdgeInsets.all(15),
                      color: Colors.pink.shade600,
                      child: Column(
                        children: [
                          ListTile(
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            title: const Text('Professeur'),
                            subtitle: Text(course['professeur']['name']),
                            leading: const Icon(Icons.person),
                          ),
                          ListTile(
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            title: const Text('Module'),
                            subtitle: Text(course['module']['libelle']),
                            leading: const Icon(Icons.book),
                          ),
                          ListTile(
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            title: const Text('Classe'),
                            subtitle: Text(course['classe']['libelle']),
                            leading: const Icon(Icons.school),
                          ),
                          ListTile(
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            title: const Text('Semestre'),
                            subtitle: Text(course['semestre']['libelle']),
                            leading: const Icon(Icons.calendar_today),
                          ),
                          ListTile(
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            title: const Text('Heure globale'),
                            subtitle: Text(course['heure_globale'].toString()),
                            leading: const Icon(Icons.timer),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            ConvexAppBar(
              backgroundColor: Colors.pink.shade600,
              color: Colors.white,
              items: const [
                TabItem(icon: Icons.school, title: 'Cours'),
                TabItem(icon: Icons.calendar_month, title: 'Session'),
                TabItem(icon: Icons.exit_to_app, title: 'Logout'),
              ],
              onTap: (int i) async {
                if (i == 2) {
                  await logout();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
