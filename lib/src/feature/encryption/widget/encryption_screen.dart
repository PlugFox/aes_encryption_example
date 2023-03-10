import 'package:flutter/material.dart';

import 'encryption_form.dart';
import 'encryption_scope.dart';

/// {@template encryption_screen}
/// EncryptionScreen widget
/// {@endtemplate}
class EncryptionScreen extends StatelessWidget {
  /// {@macro encryption_screen}
  const EncryptionScreen({super.key});

  @override
  Widget build(BuildContext context) => const EncryptionScope(
        child: Scaffold(
          body: SafeArea(
            child: EncryptionForm(),
          ),
        ),
      );
}
