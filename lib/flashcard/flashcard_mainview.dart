import 'package:flip_card/flip_card.dart';
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
  bool _isEnglish = true;

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage(_isEnglish ? "en-US" : "es-ES");
  }

  final List<Flashcard> _flashcards = [
    Flashcard(
        question: "What fraction does the Pizza represent?",
        answerEn: "Half", // English answer
        answerEs: "Medio", // Spanish answer
        imagePath: "assets/flashcards/half_pizza.png"
    ),
    Flashcard(
        question: "What fraction does the Cake represent?",
        answerEn: "Three Fourths!",
        answerEs: "Tres Cuartos!",
        imagePath: "assets/flashcards/three_fourth_cake.png"
    ),
    Flashcard(
        question: "What fraction does the Lemon represent?",
        answerEn: "One Third!",
        answerEs: "Un Tercio!",
        imagePath: "assets/flashcards/one_third_lemon.png"
    ),
  ];

  int _currentIndex = 0;

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 500,
                height: 500,
                child: FlipCard(
                  key: cardKey,
                  flipOnTouch: true,
                  front: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            _flashcards[_currentIndex].question,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                            ),
                          ),
                          Image.asset(
                            _flashcards[_currentIndex].imagePath!,
                            width: 350,
                            height: 350,
                          ),
                        ],
                      ),
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
                  IconButton(onPressed: _currentIndex > 0 ? showPreviousCard : null, icon: Icon(Icons.arrow_back_rounded, size: 35,)),
                  IconButton(onPressed: _currentIndex < _flashcards.length - 1 ? showNextCard : null, icon: Icon(Icons.arrow_forward_rounded, size: 35,)),
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
      _isEnglish = true;
      flutterTts.setLanguage("en-US");
      cardKey = GlobalKey<FlipCardState>();
    });
  }

  void showPreviousCard(){
    setState(() {
      _currentIndex = (_currentIndex - 1 >= 0) ? _currentIndex - 1 : _flashcards.length - 1;
      _isEnglish = true;
      flutterTts.setLanguage("en-US");
      cardKey = GlobalKey<FlipCardState>();
    });
  }

}