import 'package:flutter/material.dart';



class games extends StatelessWidget {
  const games({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const MatchGame(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MatchGame extends StatefulWidget {
  const MatchGame({Key? key}) : super(key: key);

  @override
  _MatchGameState createState() => _MatchGameState();
}

class _MatchGameState extends State<MatchGame> {
  // Map of items to their matches, using item:image path format
  final Map<String, String> _items = {
    'WHOLE': 'assets/games/whole.png',
    'HALF': 'assets/games/half.png',
    'ONE TENTHS': 'assets/games/one_tenth.png',
  };

  // Track matched items to remove them
  Set<String> _matchedItems = Set();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Column for draggable items
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _items.keys.map((item) {
            if (!_matchedItems.contains(item)) {
              return Draggable<String>(
                data: item,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  color: Colors.blue,
                  height: 50,
                  width: 100,
                  child: Center(child: Text(item)),
                ),
                feedback: Material(
                  child: Container(
                    width: 100,
                    height: 50,
                    color: Colors.deepOrange,
                    child: Center(
                      child: Text(item),
                    ),
                  ),
                ),
                childWhenDragging: Container(
                  height: 50,
                  width: 100,
                  color: Colors.lightBlueAccent,
                  child: Center(child: Text(item)),
                ),
              );
            } else {
              return Container(); // Placeholder for matched items
            }
          }).toList(),
        ),
        // Column for target areas
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _items.entries.map((entry) {
            if (!_matchedItems.contains(entry.key)) {
              return DragTarget<String>(
                onAccept: (receivedItem) {
                  if (receivedItem == entry.key) {
                    setState(() {
                      _matchedItems.add(entry.key); // Mark as matched
                    });
                  }
                },
                builder: (
                    BuildContext context,
                    List<dynamic> accepted,
                    List<dynamic> rejected,
                    ) {
                  return Container(
                    height: 100, // Adjusted for image size
                    width: 100, // Adjusted for image size
                    color: Colors.grey[300], // Optional: Background color for the target area
                    child: Image.asset(entry.value, fit: BoxFit.cover),
                  );
                },
                onWillAccept: (data) {
                  // Only accept the drag if it's the correct match
                  return data == entry.key;
                },
              );
            } else {
              return Container(); // Placeholder for matched targets
            }
          }).toList(),
        ),
      ],
    );
  }
}
