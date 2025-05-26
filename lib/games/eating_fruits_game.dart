import 'package:bilingual_fractions_flutter_app/games/fruits_basket_game.dart';
import 'package:flutter/material.dart';

class EatingFruitsGame extends StatefulWidget {
  @override
  _EatingFruitsGameState createState() => _EatingFruitsGameState();
}

class GameSet {
  final String question;
  final String originalImagePath;
  final String replacementImagePath;
  final int expectedCount;
  final int totalCount;
  final double imageSize;

  GameSet({
    required this.question,
    required this.originalImagePath,
    required this.replacementImagePath,
    required this.expectedCount,
    required this.totalCount,
    required this.imageSize,
  });
}

final List<GameSet> gameset = [
  GameSet(
    question: "Eat Two Fifths of the Apples",
    originalImagePath: 'assets/games/apple.png',
    replacementImagePath: 'assets/games/eaten_apple.png',
    expectedCount: 2,
    totalCount: 5,
    imageSize: 300,
  ),
  GameSet(
    question: "Eat Half of the Bananas",
    originalImagePath: 'assets/games/banana.png',
    replacementImagePath: 'assets/games/eaten_banana.png',
    expectedCount: 4,
    totalCount: 8,
    imageSize: 200,
  ),
  GameSet(
    question: "Eat One Third of the Grapes Bunch",
    originalImagePath: 'assets/games/grapes.png',
    replacementImagePath: 'assets/games/eaten_grapes.png',
    expectedCount: 1,
    totalCount: 3,
    imageSize: 350,
  ),
];

class _EatingFruitsGameState extends State<EatingFruitsGame> {
  late List<bool> clickedStatus;

  int _currentIndex = 0;
  int score = 0;
  bool gameOver = false;
  late int replacedCount;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  initGame() {
    clickedStatus = List<bool>.filled(gameset[_currentIndex].totalCount, false);
    gameOver = false;
  }

  void showTemporaryPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22)),
              ],
            ),
          ),
        );
      },
    );
  }

  void onSubmit() {
    replacedCount = clickedStatus.where((status) => status).length;

    if (replacedCount == gameset[_currentIndex].expectedCount) {
      score += 10;
    } else {
      score -= 5;
    }
    gameOver = true;

    setState(() {});
  }

  void showNextSet() {
    setState(() {
      gameOver = false;
      if (_currentIndex < gameset.length - 1) {
        _currentIndex++;
      }
    });
  }

  void showPreviousSet() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSet = gameset[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: IconButton(
              icon: const Icon(
                Icons.info,
                size: 35,
              ),
              onPressed: () {
                showTemporaryPopup("Click on the fruits to eat them!");
              },
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //const SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              currentSet.question,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 34),
            ),
          ),
          Text.rich(TextSpan(children: [
            const TextSpan(text: "Score: ", style: TextStyle(fontSize: 25)),
            TextSpan(
                text: "$score",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ))
          ])),
          if (!gameOver)
            Expanded(
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children:
                      List<Widget>.generate(clickedStatus.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          clickedStatus[index] = !clickedStatus[index];
                        });
                      },
                      child: Container(
                        width: currentSet.imageSize,
                        height: currentSet.imageSize,
                        child: Image.asset(
                          clickedStatus[index]
                              ? currentSet.replacementImagePath
                              : currentSet.originalImagePath,
                          key: UniqueKey(),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          if (gameOver)
            Text(
              "\nEaten Fruits: $replacedCount\nFraction of Eaten Fruits to Total Fruits: $replacedCount/${currentSet.totalCount}\n\n${replacedCount == currentSet.expectedCount ? "Yayyyy! You've won" : "Oops! You didn't match the fraction"}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 35),
                onPressed: () {
                  if (_currentIndex > 0) {
                    showPreviousSet();
                    setState(() {
                      initGame();
                    });
                  } else {
                    Navigator.pop(
                        context); // If at the first index, pop the current context
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.replay, size: 35),
                onPressed: () {
                  setState(() {
                    initGame();
                  });
                },
              ),
              if (!gameOver)
                ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(95, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                  child: const Text('Submit', style: TextStyle(fontSize: 18)),
                ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_rounded, size: 35),
                onPressed: () {
                  if (_currentIndex < gameset.length - 1) {
                    showNextSet();
                    setState(() {
                      initGame();
                    });
                  } else {}
                  ;
                },
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
