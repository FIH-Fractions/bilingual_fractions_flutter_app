import 'package:flip_card/flip_card.dart';
/*import 'package:Bilingual-Fractions-Flutter-App/flashcard/flashcard.dart';
import 'package:Bilingual-Fractions-Flutter-App/flashcard/flashcard_view.dart';*/
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'flashcard.dart';
import 'flashcard_view.dart';


class flashcard extends StatefulWidget {
  const flashcard({super.key});

  @override
  State<flashcard> createState() => _flashcardState();
}

class _flashcardState extends State<flashcard> {

  final FlutterTts flutterTts = FlutterTts();
  bool _isEnglish = true; // To track the current language state

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage(_isEnglish ? "en-US" : "es-ES");
  }


  void _toggleLanguage() {
    setState(() {
      _isEnglish = !_isEnglish;
      // This setState call should cause widgets that depend on _isEnglish to rebuild
    });

  }

  List<Flashcard> _flashcards = [
    Flashcard(
        question: "What does this fraction represent",
        answerEn: "Half", // English answer
        answerEs: "Medio", // Spanish answer
        imagePath: "assets/half_pizza.png"
    ),
    Flashcard(
        question: "What does this fraction represent",
        answerEn: "Three Fourths!", // English answer
        answerEs: "Tres Cuartos!", // Example Spanish translation
        imagePath: "assets/one_fourth_pizza.png"
    ),
  ];

  int _currentIndex = 0;

  // Generate a unique key for each FlipCard based on the current index
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Current language is ${_isEnglish ? 'English' : 'Spanish'}'),
              SizedBox(
                width: 500,
                height: 500,
                child: FlipCard(
                  key: cardKey,
                  flipOnTouch: true,
                  front: Card(
                    elevation: 4,
                    child: Center(
                      child: _flashcards[_currentIndex].imagePath != null
                          ? Image.asset(_flashcards[_currentIndex].imagePath!) // Use `!` to assert that imagePath is not null
                          : Container(child: Text(_flashcards[_currentIndex].question)), // Fallback if no image
                    ),
                  ),
                  back:  FlashcardView(
                    textEn: _flashcards[_currentIndex].answerEn,
                    textEs: _flashcards[_currentIndex].answerEs,
                    onToggleLanguage: () => setState(() => _isEnglish = !_isEnglish),
                    isEnglish: _isEnglish,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                      onPressed: showPreviousCard,
                      icon: Icon(Icons.chevron_left),
                      label: Text('Prev')),
                  OutlinedButton.icon(
                      onPressed: showNextCard,
                      icon: Icon(Icons.chevron_right),
                      label: Text('Next'))
                ],
              )
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,

    );

  }
  void showNextCard(){
    setState(() {
      _currentIndex = (_currentIndex + 1 < _flashcards.length) ? _currentIndex + 1 : 0;
      cardKey = GlobalKey<FlipCardState>();
    });
  }

  void showPreviousCard(){
    setState(() {
      _currentIndex = (_currentIndex - 1 >=0) ? _currentIndex - 1 : _flashcards.length -1;
      cardKey = GlobalKey<FlipCardState>();
    });
  }

}