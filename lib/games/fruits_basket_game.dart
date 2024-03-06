import 'package:bilingual_fractions_flutter_app/games/games.dart';
import 'package:flutter/material.dart';

import '../main.dart';

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
    Fruit(type: 'apple', imagePath: 'assets/games/apple.png',),
    Fruit(type: 'apple', imagePath: 'assets/games/apple.png',),
    Fruit(type: 'lime', imagePath: 'assets/games/lime.png',),
    Fruit(type: 'banana', imagePath: 'assets/games/banana.png',),
    Fruit(type: 'banana', imagePath: 'assets/games/banana.png',),
    Fruit(type: 'banana', imagePath: 'assets/games/banana.png',),
    Fruit(type: 'lime', imagePath: 'assets/games/lime.png',),
    Fruit(type: 'grapes', imagePath: 'assets/games/grapes.png',),
    Fruit(type: 'grapes', imagePath: 'assets/games/grapes.png',),
    Fruit(type: 'grapes', imagePath: 'assets/games/grapes.png',),
  ];
  // A list to keep track of the fruits in the basket
  List<String> fruitsInBasket = [];
  List<int> gridPattern = [2, 3, 2];
  int score = 0;

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

  void initGame(){
    score=0;
    fruits = [
      Fruit(type: 'apple', imagePath: 'assets/games/apple.png', inBasket: false),
      Fruit(type: 'apple', imagePath: 'assets/games/apple.png',),
      Fruit(type: 'lime', imagePath: 'assets/games/lime.png',),
      Fruit(type: 'banana', imagePath: 'assets/games/banana.png',),
      Fruit(type: 'banana', imagePath: 'assets/games/banana.png',),
      Fruit(type: 'banana', imagePath: 'assets/games/banana.png',),
      Fruit(type: 'lime', imagePath: 'assets/games/lime.png',),
      Fruit(type: 'grapes', imagePath: 'assets/games/grapes.png',),
      Fruit(type: 'grapes', imagePath: 'assets/games/grapes.png',),
      Fruit(type: 'grapes', imagePath: 'assets/games/grapes.png',),
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
    score+=10;
    showTemporaryPopup('Your Answer is Correct! +10 points');
  });
  }

  @override
  Widget build(BuildContext context) {
    List<Fruit> inBasketFruits = fruits.where((fruit) => fruit.inBasket).toList();

    // Calculate total grid height based on the pattern and fruit size
    double gridHeight = gridPattern.fold(0, (previousValue, element) => previousValue + element) * 100; // Assuming each fruit's height is 100
    double basketTop = 75;
    return Scaffold(
      appBar: AppBar(
        title: Text('Fill The Basket'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'with One Seventh Apples, Two Seventh Grapes, Three Seventh Banana, One Seventh Lime',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Text.rich(TextSpan(
              children: [
                const TextSpan(text: "Score: ", style: TextStyle(fontSize: 24)),
                TextSpan(text: "$score", style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ))
              ]
          )
          ),
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: DragTarget<Fruit>(
                    onAccept: isFruitInBasket,
                    builder: (context, acceptedFruits, rejectedFruits) {
                      return Image.asset('assets/games/basket.png', width: 750, height: 750, fit: BoxFit.fitWidth);
                    },
                  ),
                ),
                ...fruits.asMap().entries.map((entry) {
                  int index = entry.key;
                  Fruit fruit = entry.value;
                  double top = (index % 5) * 100;
                  double left = (index < 5) ? 90 : MediaQuery.of(context).size.width - 190;
                  return Positioned(
                    top: top,
                    left: left,
                    child: Draggable<Fruit>(
                      data: fruit,
                      child: !fruit.inBasket ? Image.asset(fruit.imagePath, width: 90, height: 90) : Container(),
                      feedback: Image.asset(fruit.imagePath, width: 100, height: 100),
                      childWhenDragging: Container(),
                      onDragCompleted: () {}, // Optional, if you want to do something when drag is completed
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

                  int rowIndex = index - (cumulative - gridPattern[row]); // Index within the current row
                  int itemsInRow = gridPattern[row];

                  double rowWidth = itemsInRow * 100; // Assuming each fruit's width is 100
                  double rowLeftStart = (MediaQuery.of(context).size.width - rowWidth) / 2; // Centering the row

                  double top = basketTop + row * 100; // Row position
                  double left = rowLeftStart + rowIndex * 100; // Position within the row

                  return Positioned(
                    top: top,
                    left: left,
                    child: GestureDetector(
                      onTap: () => isFruitInBasket(fruit),
                      child: Image.asset(fruit.imagePath, width: 110, height: 110),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Fruits in basket: ${fruits.where((fruit) => fruit.inBasket).length}", style: TextStyle(fontSize: 18),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 35),
                onPressed: () {Navigator.pop(context);},
              ),
              IconButton(
                icon: const Icon(Icons.replay, size: 35),
                onPressed: () {
                  setState(() {
                    initGame();
                  });
                },
              ),
              ElevatedButton(
                  onPressed: () {onSubmit();},
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
                onPressed: () {}
              ),
            ],
          ),
          const SizedBox(height: 25,),
        ],
      ),
    );
  }
}