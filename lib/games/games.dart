import 'package:flutter/material.dart';

class games extends StatelessWidget {
  const games({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: MatchGame(),
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
    'Whole': 'assets/games/whole.png',
    'Half': 'assets/games/half.png',
    'One Tenths': 'assets/games/one_tenth.png',
  };

  // Track matched items to remove them
  Set<String> _matchedItems = Set();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Match the following',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _items.keys.map((item) {
                  if (!_matchedItems.contains(item)) {
                    return Draggable<String>(
                      data: item,
                      feedback: Material(
                        child: Container(
                          height: 80,
                          width: 170,
                          color: Color(0xFFF354D0),
                          child: Center(
                              child: Text(
                                item,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 24,),
                              )
                          ),
                        ),
                      ),
                      childWhenDragging: Container(
                        height: 80,
                        width: 170,
                        color: Color(0xFFE5C5DD),
                        child: Center(
                            child: Text(
                              item,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 24,),
                            )
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        color: Color(0xFFE5C5DD),
                        height: 80,
                        width: 170,
                        child: Center(
                            child: Text(
                              item,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 24,),
                            )
                        ),
                      ),
                    );
                  } else {
                    return Container(); // Placeholder for matched items
                  }
                }).toList(),
              ),
          // Column for target areas
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        height: 140,
                        width: 140,
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
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.arrow_back_rounded, size: 35,), onPressed: () {  },),
            IconButton(
              icon: Icon(Icons.replay, size: 35,),
              onPressed: () {
                setState(() {
                  _matchedItems.clear();
                });
              },
            ),
            IconButton(icon: Icon(Icons.arrow_forward_rounded, size: 35,), onPressed: () {  },),
          ],
        ),
      ],
    );
  }
}
