import 'package:flutter/material.dart';

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
            Text(
              'FRACTIONS',
              style: TextStyle(
                fontSize: 75,
              ),
            ),
            Image.asset(
              'assets/fraction_logo.png',
            ),
          ],
        ),
      ),
    );
  }
}