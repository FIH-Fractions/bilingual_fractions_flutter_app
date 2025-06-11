import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/gemini_chat_service.dart';

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

  TextEditingController _chatController = TextEditingController();
  String _aiResponse = "Hi! I'm your Fruit AI Helper.";

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
          content: SizedBox(
            height: 100,
            child: Center(
              child: Text(message,
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
            ),
          ),
        );
      },
    );
  }

  List<Map<String, String>> _chatHistory = [];

  void showChatbotPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStatePopup) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Container(
                width: double.maxFinite,
                height: 500,
                child: Column(
                  children: [
                    const Text("Math Helper",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _chatHistory.length,
                        itemBuilder: (context, index) {
                          final entry = _chatHistory[index];
                          final isUser = entry['role'] == 'user';
                          return Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? Colors.blue.shade100
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                entry['text']!,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _chatController,
                      decoration: const InputDecoration(
                        hintText: "Ask for a hint...",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final userMessage = _chatController.text;
                        if (userMessage.trim().isEmpty) return;

                        _chatController.clear();

                        setState(() {
                          _chatHistory
                              .add({"role": "user", "text": userMessage});
                        });

                        final gameContext = gameset[_currentIndex].question;
                        final aiReply = await GeminiChatService.getHint(
                            userMessage, gameContext);

                        setStatePopup(() {
                          _chatHistory.add({"role": "model", "text": aiReply});
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8F87F1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Get Hint"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void onSubmit() {
    replacedCount = clickedStatus.where((status) => status).length;
    score += (replacedCount == gameset[_currentIndex].expectedCount) ? 10 : -5;
    gameOver = true;
    setState(() {});
  }

  void showNextSet() {
    setState(() {
      gameOver = false;
      if (_currentIndex < gameset.length - 1) {
        _currentIndex++;
        initGame();
      }
    });
  }

  void showPreviousSet() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
        initGame();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSet = gameset[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.info, size: 30),
            onPressed: () =>
                showTemporaryPopup("Click on the fruits to eat them!"),
          ),
          IconButton(
            icon: const Icon(Icons.smart_toy, size: 30),
            onPressed: showChatbotPopup,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(currentSet.question,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 34)),
          ),
          Text.rich(TextSpan(children: [
            const TextSpan(text: "Score: ", style: TextStyle(fontSize: 25)),
            TextSpan(
                text: "$score",
                style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 25))
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
              style: const TextStyle(color: Colors.black, fontSize: 24),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (!gameOver)
                ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8F87F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Submit'),
                ),
              if (gameOver) ...[
                ElevatedButton(
                  onPressed: () => _currentIndex > 0
                      ? showPreviousSet()
                      : Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8F87F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => initGame()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8F87F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Replay'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentIndex < gameset.length - 1) {
                      showNextSet();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8F87F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Next'),
                ),
              ]
            ],
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
