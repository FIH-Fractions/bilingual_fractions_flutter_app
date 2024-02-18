import 'package:flutter/material.dart';

class quiz extends StatefulWidget {
  const quiz({super.key});

  @override
  State<quiz> createState() => _quiz();
}

class _quiz extends State<quiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Quiz',
              style: TextStyle(
                fontSize: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}