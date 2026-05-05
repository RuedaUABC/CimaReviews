import 'package:flutter/material.dart';
import 'package:cimareviews/ui/views/home_view.dart';
import 'package:cimareviews/ui/views/login_view.dart';
import 'package:cimareviews/ui/views/register_user_view.dart';

Map<String, WidgetBuilder> routes() {
  return {
    '/': (context) => const HomeView(title: 'CimaReviews Home Page'),
    '/login': (context) => const LoginView(),
    '/register': (context) => const RegisterUserView(),
  };
}
