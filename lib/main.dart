import 'package:bilingual_fractions_flutter_app/games/fruits_basket_game.dart';
import 'package:flutter/material.dart';
import 'flashcard/flashcard_mainview.dart';
import 'games/games.dart';
import 'home/home.dart';
import 'profile/progress.dart';
import 'quiz/quiz.dart';

void main() => runApp(const BottomNavBarApp());

class BottomNavBarApp extends StatelessWidget {
  const BottomNavBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavBar(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    home(),
    QuizPage(),
    flashcard(),
    Games(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: IconButton(
            icon: const Icon(
              Icons.person,
              size: 35,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => progress()),
              );
            },
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                Icons.translate_rounded,
                size: 35,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
              size: 35,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.school_rounded,
              size: 35,
            ),
            label: 'Quizzes',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.amp_stories_rounded,
              size: 35,
            ),
            label: 'Flashcards',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.sports_esports,
              size: 35,
            ),
            label: 'Games',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
