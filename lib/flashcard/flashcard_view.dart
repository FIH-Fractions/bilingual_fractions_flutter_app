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
    return Card(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              isEnglish ? textEn : textEs,
              style: const TextStyle(
                fontSize: 60,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.volume_up_rounded),
                  onPressed: () {
                    // Handle the volume action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.translate_rounded),
                  onPressed: onToggleLanguage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


