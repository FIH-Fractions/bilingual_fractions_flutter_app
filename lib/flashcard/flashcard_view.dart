import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FlashcardView extends StatelessWidget {

  final String textEn;
  final String textEs;
  final VoidCallback onToggleLanguage;
  final bool isEnglish;
  final FlutterTts flutterTts;

  FlashcardView({
    Key? key,
    required this.textEn,
    required this.textEs,
    required this.onToggleLanguage,
    required this.isEnglish,
    required this.flutterTts,
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
                  icon: const Icon(Icons.volume_up_rounded),
                  onPressed: () async {
                    var text = isEnglish ? textEn : textEs;
                    await flutterTts.setLanguage(isEnglish ? "en-US" : "es-ES");
                    await flutterTts.speak(text);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.translate_rounded),
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


