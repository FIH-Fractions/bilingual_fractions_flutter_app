import 'package:flutter/material.dart';

class FlashcardView extends StatelessWidget {

  final String textEn;
  final String textEs;
  final VoidCallback onToggleLanguage;
  final bool isEnglish;



  FlashcardView({
    Key? key,
    required this.textEn,
    required this.textEs,
    required this.onToggleLanguage,
    required this.isEnglish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isEnglish = Localizations.localeOf(context).languageCode == 'en';
    return Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display logic is handled outside, so this widget just uses the provided text
          Text(isEnglish ? textEn : textEs, textAlign: TextAlign.center),
          ElevatedButton(
            onPressed: onToggleLanguage,
            child: Text(isEnglish ? 'Switch to Spanish' : 'Switch to English'),
          ),
        ],
      ),
    );
  }
}


