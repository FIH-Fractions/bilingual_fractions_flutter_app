import 'package:bilingual_fractions_flutter_app/games/games.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../services/gemini_chat_service.dart';

class FruitsBasketGame extends StatefulWidget {
  @override
  _FruitsBasketGameState createState() => _FruitsBasketGameState();
}

class Fruit {
  String type;
  final String imagePath;
  bool inBasket;

  Fruit({required this.type, required this.imagePath, this.inBasket = false});
}

class _FruitsBasketGameState extends State<FruitsBasketGame> {
  List<Fruit> fruits = [
    Fruit(
      type: 'apple',
      imagePath: 'assets/games/apple.png',
    ),
    Fruit(
      type: 'apple',
      imagePath: 'assets/games/apple.png',
    ),
    Fruit(
      type: 'lime',
      imagePath: 'assets/games/lime.png',
    ),
    Fruit(
      type: 'banana',
      imagePath: 'assets/games/banana.png',
    ),
    Fruit(
      type: 'banana',
      imagePath: 'assets/games/banana.png',
    ),
    Fruit(
      type: 'banana',
      imagePath: 'assets/games/banana.png',
    ),
    Fruit(
      type: 'lime',
      imagePath: 'assets/games/lime.png',
    ),
    Fruit(
      type: 'grapes',
      imagePath: 'assets/games/grapes.png',
    ),
    Fruit(
      type: 'grapes',
      imagePath: 'assets/games/grapes.png',
    ),
    Fruit(
      type: 'grapes',
      imagePath: 'assets/games/grapes.png',
    ),
  ];
  // A list to keep track of the fruits in the basket
  List<String> fruitsInBasket = [];
  List<int> gridPattern = [1, 3, 1];
  int score = 0;

  // Add these new variables for chatbot
  TextEditingController _chatController = TextEditingController();
  List<Map<String, String>> _chatHistory = [];

  void isFruitInBasket(Fruit fruit) {
    setState(() {
      fruit.inBasket = !fruit.inBasket;
    });
  }

  @override
  void initState() {
    super.initState();
    initGame(); // Initialize the game when the widget is first created
  }

  void initGame() {
    score = 0;
    fruits = [
      Fruit(
          type: 'apple', imagePath: 'assets/games/apple.png', inBasket: false),
      Fruit(
        type: 'apple',
        imagePath: 'assets/games/apple.png',
      ),
      Fruit(
        type: 'lime',
        imagePath: 'assets/games/lime.png',
      ),
      Fruit(
        type: 'banana',
        imagePath: 'assets/games/banana.png',
      ),
      Fruit(
        type: 'banana',
        imagePath: 'assets/games/banana.png',
      ),
      Fruit(
        type: 'banana',
        imagePath: 'assets/games/banana.png',
      ),
      Fruit(
        type: 'lime',
        imagePath: 'assets/games/lime.png',
      ),
      Fruit(
        type: 'grapes',
        imagePath: 'assets/games/grapes.png',
      ),
      Fruit(
        type: 'grapes',
        imagePath: 'assets/games/grapes.png',
      ),
      Fruit(
        type: 'grapes',
        imagePath: 'assets/games/grapes.png',
      ),
    ];
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
    setState(() {
      // Calculate the number of each fruit type in the basket
      int apples = fruits
          .where((fruit) => fruit.inBasket && fruit.type == 'apple')
          .length;
      int grapes = fruits
          .where((fruit) => fruit.inBasket && fruit.type == 'grapes')
          .length;
      int bananas = fruits
          .where((fruit) => fruit.inBasket && fruit.type == 'banana')
          .length;
      int limes = fruits
          .where((fruit) => fruit.inBasket && fruit.type == 'lime')
          .length;

      // Check if the quantities match the required numbers
      if (apples == 1 && grapes == 2 && bananas == 1 && limes == 1) {
        score += 10;
        showTemporaryPopup('Your Answer is Correct! +10 points');
      } else {
        score -= 5; // Deduct 5 points if the combination is not correct
        showTemporaryPopup('Incorrect! -5 points. Try again.');
      }
    });
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
Game Title: Let's create a balanced fruit basket using fractions!
Instructions: Create a balanced fruit basket with one-nth Apples, two-nth Grapes, one-nth Bananas, and one-nth Lime.
Current Task: Match each fruit to its fraction and create a balanced basket.
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
    List<Fruit> inBasketFruits =
        fruits.where((fruit) => fruit.inBasket).toList();

    // Calculate total grid height based on the pattern and fruit size
    double gridHeight = gridPattern.fold(
            0, (previousValue, element) => previousValue + element) *
        100; // Assuming each fruit's height is 100
    double basketTop = 75;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lets create a balanced fruit basket using fractions! Add n number of fruits including:',
          style: TextStyle(fontSize: 24),
        ),
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
                    "Drag the fruits in the basket! Click to remove them!");
              },
            ),
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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'one-nth Apples, two-nth Grapes, one-nth Bananas, one-nth Lime. Can you match each fruit to its fraction? Lets see!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
          ),
          Text.rich(TextSpan(children: [
            const TextSpan(text: "Score: ", style: TextStyle(fontSize: 24)),
            TextSpan(
                text: "$score",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ))
          ])),
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: DragTarget<Fruit>(
                    onAccept: isFruitInBasket,
                    builder: (context, acceptedFruits, rejectedFruits) {
                      return Image.asset('assets/games/basket.png',
                          width: 750, height: 750, fit: BoxFit.fitWidth);
                    },
                  ),
                ),
                ...fruits.asMap().entries.map((entry) {
                  int index = entry.key;
                  Fruit fruit = entry.value;
                  double top = (index % 5) * 100;
                  double left = (index < 5)
                      ? 90
                      : MediaQuery.of(context).size.width - 190;
                  return Positioned(
                    top: top,
                    left: left,
                    child: Draggable<Fruit>(
                      data: fruit,
                      child: !fruit.inBasket
                          ? Image.asset(fruit.imagePath, width: 90, height: 90)
                          : Container(),
                      feedback:
                          Image.asset(fruit.imagePath, width: 100, height: 100),
                      childWhenDragging: Container(),
                      onDragCompleted:
                          () {}, // Optional, if you want to do something when drag is completed
                    ),
                  );
                }).toList(),
                ...inBasketFruits.asMap().entries.map((entry) {
                  int index = entry.key;
                  Fruit fruit = entry.value;

                  int row = 0;
                  int cumulative = 0;
                  basketTop = 100;

                  for (int i = 0; i < gridPattern.length; i++) {
                    cumulative += gridPattern[i];
                    if (index < cumulative) {
                      row = i;
                      break;
                    }
                  }

                  int rowIndex = index -
                      (cumulative -
                          gridPattern[row]); // Index within the current row
                  int itemsInRow = gridPattern[row];

                  double rowWidth =
                      itemsInRow * 100; // Assuming each fruit's width is 100
                  double rowLeftStart =
                      (MediaQuery.of(context).size.width - rowWidth) /
                          2; // Centering the row

                  double top = basketTop + row * 100; // Row position
                  double left =
                      rowLeftStart + rowIndex * 100; // Position within the row

                  return Positioned(
                    top: top,
                    left: left,
                    child: GestureDetector(
                      onTap: () => isFruitInBasket(fruit),
                      child:
                          Image.asset(fruit.imagePath, width: 110, height: 110),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Fruits in basket: ${fruits.where((fruit) => fruit.inBasket).length}",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (!score.isFinite || score == 0)
                ElevatedButton(
                  onPressed: () {
                    onSubmit();
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
                  child: const Text('Submit'),
                ),
              if (score.isFinite && score != 0)
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
