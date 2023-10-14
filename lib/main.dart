import 'package:flutter/material.dart';
import 'package:gestion_pedagogique_flutter/router/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   bool isLoggedIn = false; 

  void login() {
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Gestion Pedagogique",
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    
    );
  }
}
