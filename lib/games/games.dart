import 'package:bilingual_fractions_flutter_app/games/fruits_basket_game.dart';
import 'package:flutter/material.dart';
import 'matching_game.dart';
import 'eating_fruits_game.dart';
import 'exercise.dart';
import 'pronunciation_game.dart';

class Games extends StatelessWidget {
  const Games({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Use SingleChildScrollView for vertical scrolling
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // Use Column for vertical layout
            children: <Widget>[
              // Write Fractions Game
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FractionWritingGame()),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  height: 150,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 162, 209, 194),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Write Fractions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  ),
                ),
              ),
              // Speak Fractions Game
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PronunciationGame()),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  height: 150,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF7ABDA9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Speak Fractions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  ),
                ),
              ),
              // Matching Game
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MatchingGame()),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  height: 150,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF649889),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Match The Fractions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  ),
                ),
              ),
              // Eating Fruits Game
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EatingFruitsGame()),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  height: 150,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF476E62),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Eat The Fruits',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  ),
                ),
              ),
              // Fruits Basket Game
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FruitsBasketGame()),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  height: 150,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF2E4F47),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Fruits Basket Game',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
