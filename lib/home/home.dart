import 'package:flutter/material.dart';
import 'package:bilingual_fractions_flutter_app/learn/learn_slides.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _home();
}

class _home extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'FRACTIONS',
              style: TextStyle(
                fontSize: 85,
              ),
            ),
            Image.asset(
              'assets/fraction_logo.png',
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LearnPage()),
                );
              },
              child: Container(
                width: 370, // Adjust width to fit the screen
                height: 130, // Fixed height for uniformity
                margin: const EdgeInsets.only(bottom: 10), // Add margin to separate tiles
                decoration: BoxDecoration(
                  color: Color(0xA150B085),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Learn!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}