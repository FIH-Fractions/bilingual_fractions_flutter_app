import 'package:flutter/material.dart';

void main() {
  runApp(FractionApp());
}

class FractionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fractions App',
      theme: ThemeData(
        primaryColor: Colors.brown[100],
        scaffoldBackgroundColor: Colors.brown[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.brown[100],
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.orange[50]),
      ),
      home: FractionPage(),
    );
  }
}

class FractionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            onPressed: () {
              // Add functionality for home button
            },
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                // Add functionality for language switch
              },
              child: Text(
                'Español',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 26.0,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 2), // Adjust the spacing
            Text(
              'FRACTIONS',
              style: TextStyle(
                fontFamily: 'KidsFont',
                fontWeight: FontWeight.bold,
                fontSize: 86.0,
                //color: Colors.black,
                //backgroundColor: Colors.black, // Highlighted background color
              ),
            ),
            Image.asset(
              'assets/fraction_logo.png',
              height: 150,
              width: 150,
            ),
            SizedBox(height: 20),
            FractionButton(
              title: 'GAMES',
              onPressed: () {
                // Add functionality
              },
            ),
            FractionButton(
              title: 'FLASHCARDS',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlashcardsPage()),
                );
              },
            ),
            FractionButton(
              title: 'QUIZ',
              onPressed: () {
                // Add functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FractionButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  FractionButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 500.0), // Adjusted padding
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => onPressed(),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange[50]!),
            textStyle: MaterialStateProperty.all<TextStyle>(
              TextStyle(
                color: Colors.black,
                fontSize: 18.0, // Adjusted font size
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 4.0), // Adjusted button height
            ),
          ),
          child: Text(title),
        ),
      ),
    );
  }
}

class FlashcardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                // Add functionality for language switch
              },
              child: Text(
                'Español',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 26.0,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Flashcard', // Adjusted to "Flashcard"
              style: TextStyle(
                fontFamily: 'KidsFont',
                fontWeight: FontWeight.bold,
                fontSize: 86.0,
                //color: Colors.black,
                //backgroundColor: Colors.black, // Highlighted background color
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 300,
              height: 400,
              color: Colors.red,
              child: Image.asset(
                'assets/Flashcard.png', // Replace 'flashcard_image.png' with your image asset path
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}