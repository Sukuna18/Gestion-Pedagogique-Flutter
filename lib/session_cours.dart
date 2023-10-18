import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SessionCours extends StatefulWidget {
  const SessionCours({super.key});

  @override
  State<SessionCours> createState() => _SessionCoursState();
}

class _SessionCoursState extends State<SessionCours> {
  List<dynamic> sessions = [];

  DateTime selectedDate = DateTime.now();

  Future<void> getSessions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    String formattedDate =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    String url ="http://127.0.0.1:8000/api/sessions?date=$formattedDate";
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        sessions = jsonDecode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load sessions');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      getSessions();
    }
  }

  void fetchData(String url) {}
  @override
  void initState() {
    getSessions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gestion Pedagogique",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Liste des sessions de cours')),
          backgroundColor: Colors.pink.shade600,
          actions: [
            IconButton(
              icon: const Icon(Icons.date_range),
              onPressed: () => _selectDate(context),
            ),
          ],
        ),
        body: Container(
          color: Colors.pink.shade100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Selected Date: ${selectedDate.toString().substring(0, 10)}', style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink.shade600)),
              Expanded(
                child: ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return Card(
                      margin: const EdgeInsets.all(15),
                      color: Colors.pink.shade600,
                      child: Column(
                        children: [
                          ListTile(
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            title: const Text('Heure de début'),
                            subtitle: Text(session['heure_debut']),
                            leading: const Icon(Icons.timer),
                          ),
                          ListTile(
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            title: const Text('Heure de fin'),
                            subtitle: Text(session['heure_fin']),
                            leading: const Icon(Icons.timer),
                          ),
                          ListTile(
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            title: const Text('Format'),
                            subtitle: Text(session['en_ligne'] == 1 ? 'En ligne' : 'En présentiel'),
                            leading: const Icon(Icons.computer),
                          ),
                          if (session['en_ligne'] == 0)
                            ListTile(
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              title: const Text('Salle'),
                              subtitle: Text(session['salle']['libelle'] ?? 'Aucune salle attribuée'),
                              leading: const Icon(Icons.school),
                            ),
                          ListTile(
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            title: const Text('Cours'),
                            subtitle: Text(session['cours']['module']['libelle']),
                            leading: const Icon(Icons.book),
                          ),
                          ListTile(
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            title: const Text('Professeur'),
                            subtitle: Text(session['cours']['professeur']['name']),
                            leading: const Icon(Icons.person),
                          ),
                          ListTile(
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            title: const Text('Classe'),
                            subtitle: Text(session['cours']['classe']['libelle']),
                            leading: const Icon(Icons.school),
                          ),
                          ListTile(
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            title: const Text('Semestre'),
                            subtitle: Text(session['cours']['semestre']['libelle']),
                            leading: const Icon(Icons.calendar_today),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
