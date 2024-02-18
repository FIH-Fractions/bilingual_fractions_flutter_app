import 'package:flutter/material.dart';

class games extends StatefulWidget {
  const games({super.key});

  @override
  State<games> createState() => _games();
}

class _games extends State<games> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Games',
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