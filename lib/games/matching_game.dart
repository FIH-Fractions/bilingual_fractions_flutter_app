import 'package:flutter/material.dart';
import 'apples_game.dart';

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

  @override
  void initState() {
    super.initState();
    initGame();
  }

  initGame(){
    gameOver = false;
    score=0;
    items = [
      ItemModel(imagePath: 'assets/games/half.png', name: "Half", value: "Half"),
      ItemModel(imagePath: 'assets/games/one_tenth.png', name: "One Tenth", value: "One Tenth"),
      ItemModel(imagePath: 'assets/games/whole.png', name: "Whole", value: "Whole"),
    ];
    shuffledItems = List<ItemModel>.from(items);
    items.shuffle();
    shuffledItems.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    if(items.isEmpty) {
      gameOver = true;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Match the Fractions',
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
        if(!gameOver)
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
                            color: Colors.grey[200],
                            width: 160,
                            height: 80,
                            alignment: Alignment.center,
                            child: Text(
                              item.name,
                              style: const TextStyle(color: Colors.grey, fontSize: 25),
                            ),
                          ),
                          feedback: Material(
                            color: Colors.transparent,
                            child: Container(
                              color: Colors.blue,
                              width: 160,
                              height: 80,
                              alignment: Alignment.center,
                              child: Text(
                                item.name,
                                style: const TextStyle(color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                          child: Container(
                            color: Colors.blue,
                            width: 160,
                            height: 80,
                            alignment: Alignment.center,
                            child: Text(
                              item.name,
                              style: const TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                      );
                    }).toList()
                ),

                // Column for target areas
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: shuffledItems.map((item){
                      return DragTarget<ItemModel>(
                        onAccept: (receivedItem){
                          if(item.value== receivedItem.value){
                            setState(() {
                              items.remove(receivedItem);
                              shuffledItems.remove(item);
                              score+=10;
                            });

                          }else{
                            setState(() {
                              score-=5;
                            });
                          }
                        },
                        onWillAccept: (receivedItem){
                          return true;
                        },
                        builder: (context, acceptedItems,rejectedItem) => Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(8.0),
                          constraints: const BoxConstraints(
                            maxWidth: 140,
                            maxHeight: 140,
                          ),
                          child: Image.asset(item.imagePath, fit: BoxFit.cover),
                        ),
                      );
                    }).toList()
                ),
              ],
            ),
          ),
        if(gameOver)
          const Text("Well Played!", style: TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.arrow_back_rounded, size: 35,), onPressed: () {  },),
            IconButton(
              icon: const Icon(Icons.replay, size: 35,),
              onPressed: () {
                setState(() {
                  initGame();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_rounded, size: 35,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApplesGame()),
                );
              },),
          ],
        ),
      ],
    );
  }
}

class ItemModel {
  final String name;
  final String value;
  final String imagePath;
  ItemModel({
    required this.name, required this.value, required this.imagePath,
  });
}