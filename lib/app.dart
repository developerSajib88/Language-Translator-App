import 'package:flutter/material.dart';
import 'package:language_translator/translator_screen.dart';

class LanguageTranslator extends StatelessWidget {
  const LanguageTranslator({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TranslatorScreen(),
    );
  }
}