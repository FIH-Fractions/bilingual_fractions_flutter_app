import 'package:flutter/material.dart';

class ApplesGame extends StatefulWidget {

  @override
  _ApplesGameState createState() => _ApplesGameState();
}

class GameSet {
  final String question;
  final String originalImagePath;
  final String replacementImagePath;
  final int expectedCount;

  GameSet({
    required this.question,
    required this.originalImagePath,
    required this.replacementImagePath,
    required this.expectedCount,
  });
}

final List<GameSet> gameset = [
  GameSet(
    question: "Eat Four Fifths of the Apples",
    originalImagePath: 'assets/games/apple.jpg',
    replacementImagePath: 'assets/games/eaten_apple.jpg',
    expectedCount: 4,
  ),

  GameSet(
    question: "Eat Half of the Bananas",
    originalImagePath: 'assets/games/banana.jpg',
    replacementImagePath: 'assets/games/eaten_banana.jpg',
    expectedCount: 3,
  ),
];

class _ApplesGameState extends State<ApplesGame> {
  late List<bool> clickedStatus;

  int _currentIndex = 0;
  int score = 0;
  bool gameOver = false;
  late int replacedCount;
  late int originalCount;
  late int totalCount;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  initGame() {
    clickedStatus = List<bool>.filled(5, false);
    gameOver = false;
    score = 0;
  }

  void onSubmit() {
    replacedCount = clickedStatus.where((status) => status).length;
    originalCount = clickedStatus.length - replacedCount;
    totalCount = clickedStatus.length;

    if (replacedCount == gameset[0].expectedCount) {
      score += 10;
    } else {
      score -= 5;
    }
    gameOver = true;

    setState(() {});
  }

  void _showNextQuestion() {
    setState(() {
      gameOver=false;
      if (_currentIndex < gameset.length - 1) {
        _currentIndex++;
      }
    });
  }

  void _showPreviousQuestion() {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Eat Three Fifths of the Apples',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
          ),
          Text.rich(TextSpan(
              children: [
                const TextSpan(text: "Score: ", style: TextStyle(fontSize: 25)),
                TextSpan(text: "$score", style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ))
              ]
          )
          ),
          if (!gameOver)
            Expanded(
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: List<Widget>.generate(clickedStatus.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          clickedStatus[index] = !clickedStatus[index];
                        });
                      },
                      child: Container(
                        width: 300, // Adjust the width as needed
                        height: 300, // Adjust the height as needed
                        child: Image.asset(
                          clickedStatus[index] ? currentSet.replacementImagePath : currentSet.originalImagePath,
                          key: UniqueKey(),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          if (gameOver)
            Text("\nEaten Apples: $replacedCount\nFraction of Eaten Apples to Total Apples: $replacedCount/$totalCount\n\n${replacedCount == currentSet.expectedCount ? "Yayyyy! You've won" : "Oops! You didn't match the fraction"}",
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
                onPressed: () => {
                _currentIndex > 0 ? _showPreviousQuestion() : null
                }
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
                    primary: Colors.green,
                    onPrimary: Colors.black,
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
                  _currentIndex < gameset.length - 1 ? _showNextQuestion : null;
                },
              ),
            ],
          ),
          const SizedBox(height: 25,),
        ],
      ),
    );
  }
}
