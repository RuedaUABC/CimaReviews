import 'package:flutter/material.dart';
import 'package:cimareviews/app/theme.dart';
import 'package:cimareviews/app/routes.dart';
import 'package:cimareviews/data/services/auth_service.dart';

class App extends StatelessWidget {
  const App({super.key, this.initialRoute});

  final String? initialRoute;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CimaReviews',
      theme: theme(),
      initialRoute:
          initialRoute ??
          (AuthService().isAuthenticated() ? '/home' : '/login'),
      routes: routes(),
    );
  }
}
