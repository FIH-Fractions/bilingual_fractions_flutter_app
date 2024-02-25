import 'package:flutter/material.dart';

class Apples extends StatefulWidget {
  @override
  _ApplesState createState() => _ApplesState();
}

class _ApplesState extends State<Apples> {
  final List<String> imagePaths = [
    'assets/games/apple.jpg',
    'assets/games/apple.jpg',
    'assets/games/apple.jpg',
    'assets/games/apple.jpg',
    'assets/games/apple.jpg',
    // Add or remove paths as needed
  ];

  final String replacementImagePath = 'assets/games/eaten_apple.jpg';

  late List<bool> clickedStatus; // Use `late` to declare without initializing

  @override
  void initState() {
    super.initState();
    // Initialize clickedStatus here, based on the length of imagePaths
    clickedStatus = List<bool>.filled(imagePaths.length, false);
  }

  void onSubmit() {
    // Count the number of replaced images
    int replacedCount = clickedStatus.where((status) => status).length;
    int originalCount = clickedStatus.length - replacedCount;

    // Display the counts
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Results'),
          content: Text('Eaten Apples: $replacedCount\nFull Apples: $originalCount'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Eat Apples',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
          ),
          Expanded(
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: List<Widget>.generate(imagePaths.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // Toggle the clicked status for this image
                        clickedStatus[index] = !clickedStatus[index];
                      });
                    },
                    child: Container(
                      width: 300, // Adjust the width as needed
                      height: 300, // Adjust the height as needed to maintain aspect ratio
                      child: Image.asset(
                        clickedStatus[index] ? replacementImagePath : imagePaths[index],
                        key: UniqueKey(),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 35),
                onPressed: () => Navigator.pop(context),
              ),
              IconButton(
                icon: const Icon(Icons.replay, size: 35),
                onPressed: () {
                  setState(() {
                    clickedStatus = List<bool>.filled(imagePaths.length, false);
                  });
                },
              ),
              ElevatedButton(
                onPressed: onSubmit, // Call the submission logic when the button is pressed
                child: Text('Submit'),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_rounded, size: 35),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
