import 'package:bilingual_fractions_flutter_app/games/fruits_basket_game.dart';
import 'package:flutter/material.dart';
import 'matching_game.dart';
import 'eating_fruits_game.dart';

class Games extends StatelessWidget {
  const Games({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Use SingleChildScrollView for vertical scrolling
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column( // Use Column for vertical layout
            children: <Widget>[
              // Matching Game Tile
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MatchingGame()),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 32, // Adjust width to fit the screen
                  height: 150, // Fixed height for uniformity
                  margin: const EdgeInsets.only(bottom: 10), // Add margin to separate tiles
                  decoration: BoxDecoration(
                    color: Color(0xFF8502FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Match The Fractions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              // Eating Fruits Game Tile
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EatingFruitsGame()),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 32, // Adjust width to fit the screen
                  height: 150, // Fixed height for uniformity
                  margin: const EdgeInsets.only(bottom: 10), // Add margin to separate tiles
                  decoration: BoxDecoration(
                    color: Color(0xFF01E4EC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Eat The Fruits',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              // Add a third tile here, example:
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
                    color: Color(0xFFC443A5), // Choose a different color for the third tile
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Fruits Basket Game', // Name of the third game
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
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
