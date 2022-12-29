import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../feature/encryption/widget/encryption_screen.dart';

/// {@template app}
/// App widget
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro app}
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ui.window.platformBrightness == Brightness.dark ? ThemeData.dark() : ThemeData.light(),
        themeMode: ThemeMode.system,
        home: const EncryptionScreen(),
      );
}
