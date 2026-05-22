import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cimareviews/app/app.dart';
import 'package:cimareviews/data/services/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await LocalStorageService.instance.init();
  runApp(const App());
}
