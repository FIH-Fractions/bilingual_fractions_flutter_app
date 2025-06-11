import 'package:flutter/material.dart';
import 'eating_fruits_game.dart';
import '../services/gemini_chat_service.dart';

class MatchingGame extends StatefulWidget {
  const MatchingGame({Key? key}) : super(key: key);

  @override
  _MatchingGameState createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  late List<ItemModel> items;
  late List<ItemModel> shuffledItems;
  late int score;
  late bool gameOver;
  TextEditingController _chatController = TextEditingController();
  List<Map<String, String>> _chatHistory = [];

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

  @override
  void initState() {
    super.initState();
    initGame();
  }

  initGame() {
    gameOver = false;
    score = 0;
    items = [
      ItemModel(
          imagePath: 'assets/games/half.png', name: "Half", value: "Half"),
      ItemModel(
          imagePath: 'assets/games/one_tenth.png',
          name: "One Tenth",
          value: "One Tenth"),
      ItemModel(
          imagePath: 'assets/games/whole.png', name: "Whole", value: "Whole"),
    ];
    shuffledItems = List<ItemModel>.from(items);
    items.shuffle();
    shuffledItems.shuffle();
  }

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

                        final gameContext = '''
Game Title: Match The Fractions
Available Fractions: Half, One Tenth, Whole
Current Task: Match each fraction name with its corresponding visual representation.
Instructions: Drag the fraction names from the left to match with their visual representations on the right.
''';
                        final aiReply = await GeminiChatService.getHint(
                            userMessage, gameContext);

                        setStatePopup(() {
                          _chatHistory.add({"role": "model", "text": aiReply});
                        });
                      },
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

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      gameOver = true;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Match The Fractions',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: IconButton(
                icon: const Icon(
                  Icons.info,
                  size: 35,
                ),
                onPressed: () {
                  showTemporaryPopup(
                      "Drag the Fraction on the left to the matching answer on the right!");
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.smart_toy, size: 30),
              onPressed: showChatbotPopup,
            ),
          ],
        ),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: items.map((item) {
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            child: Draggable<ItemModel>(
                              data: item,
                              childWhenDragging: Container(
                                width: 160,
                                height: 80,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 25),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              feedback: Material(
                                color: Colors.transparent,
                                child: Container(
                                  width: 160,
                                  height: 80,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4261af),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              ),
                              child: Container(
                                width: 160,
                                height: 80,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4261af),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ),
                            ),
                          );
                        }).toList()),

                    // Column for target areas
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: shuffledItems.map((item) {
                          return DragTarget<ItemModel>(
                            onAccept: (receivedItem) {
                              if (item.value == receivedItem.value) {
                                setState(() {
                                  items.remove(receivedItem);
                                  shuffledItems.remove(item);
                                  score += 10;
                                });
                              } else {
                                setState(() {
                                  score -= 5;
                                });
                              }
                            },
                            onWillAccept: (receivedItem) {
                              return true;
                            },
                            builder: (context, acceptedItems, rejectedItem) =>
                                Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(8.0),
                              constraints: const BoxConstraints(
                                maxWidth: 140,
                                maxHeight: 140,
                              ),
                              child: Image.asset(item.imagePath,
                                  fit: BoxFit.cover),
                            ),
                          );
                        }).toList()),
                  ],
                ),
              ),
            if (gameOver)
              const Text(
                "Well Played!",
                style: TextStyle(
                  color: const Color(0xFF8F87F1),
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: null,
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
                    onPressed: () {
                      setState(() {
                        initGame();
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
                    child: const Text('Replay'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
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
                ],
              ),
            ),
          ],
        )));
  }
}

class ItemModel {
  final String name;
  final String value;
  final String imagePath;
  ItemModel({
    required this.name,
    required this.value,
    required this.imagePath,
  });
}
