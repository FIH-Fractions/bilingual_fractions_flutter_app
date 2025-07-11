import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flashcard/flashcard_mainview.dart';
import 'games/games.dart';
import 'home/home.dart';
import 'learn/learn_slides.dart';
import 'quiz/quiz_selection_screen.dart'; // Updated import
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(
      fileName: "assets/.env"); // Load environment variables from assets folder

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['API_KEY']!,
        authDomain: dotenv.env['AUTH_DOMAIN']!,
        projectId: dotenv.env['PROJECT_ID']!,
        storageBucket: dotenv.env['STORAGE_BUCKET']!,
        messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
        appId: dotenv.env['APP_ID']!,
        measurementId: dotenv.env['MEASUREMENT_ID'],
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // Record app session start in analytics
  try {
    await FirebaseFirestore.instance
        .collection('analytics')
        .doc('session_start')
        .set({
      'count': FieldValue.increment(1),
    }, SetOptions(merge: true));
  } catch (e) {
    print('Error recording session start: $e');
  }

  runApp(const BottomNavBarApp());
}

class BottomNavBarApp extends StatelessWidget {
  const BottomNavBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomNavBar(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFFFA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFFFFA),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFFFFFFA),
        ),
        textTheme: GoogleFonts.comicNeueTextTheme(
          ThemeData.light().textTheme,
        ),
      ),
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
    LearnPage(),
    flashcard(),
    QuizSelectionScreen(), // Updated to use QuizSelectionScreen instead of QuizPage
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
      appBar: AppBar(),
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
            label: 'Learn',
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
              Icons.school_rounded,
              size: 35,
            ),
            label: 'Quizzes',
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
        selectedLabelStyle: const TextStyle(
          fontSize: 15, // Specify your desired font size for selected labels
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 15, // Specify your desired font size for unselected labels
        ),
        onTap: _onItemTapped,
      ),
    );
  }
}
