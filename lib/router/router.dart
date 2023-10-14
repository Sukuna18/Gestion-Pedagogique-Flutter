import 'package:gestion_pedagogique_flutter/list_cours.dart';
import 'package:gestion_pedagogique_flutter/login_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/list_cours',
      builder: (context, state) => const ListeCours(),
    ),
  ],
  redirect: (context, state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    // ignore: avoid_print
    print(token);
    if (token == null) {
      return '/';
    }else if (state.fullPath == '/') {
      return '/list_cours';
    }
    return null;
  },
);
