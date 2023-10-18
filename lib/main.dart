import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:gestion_pedagogique_flutter/login_screen.dart';
import 'package:gestion_pedagogique_flutter/list_cours.dart';
import 'package:gestion_pedagogique_flutter/session_cours.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Gestion Pedagogique",
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ListeCours(),
    const SessionCours(),
  ];

  Future<void> logout() async {
    bool confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Confirmation'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?',
              style: TextStyle(fontSize: 20)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Annuler',
                  style: TextStyle(color: Colors.red, fontSize: 20)),
            ),
            TextButton(
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.remove('token');
                if (context.mounted) {
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }
              },
              child: const Text('Déconnexion',
                  style: TextStyle(color: Colors.green, fontSize: 20)),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.pink.shade600,
        color: Colors.white,
        items: const [
          TabItem(icon: Icons.school, title: 'Cours'),
          TabItem(icon: Icons.calendar_month, title: 'Session'),
          TabItem(icon: Icons.exit_to_app, title: 'Logout'),
        ],
        onTap: (int i) async {
          if (i == 2) {
            logout();
          } else if (i != 2) {
            setState(() {
              _currentIndex = i;
            });
          }
        },
      ),
    );
  }
}
