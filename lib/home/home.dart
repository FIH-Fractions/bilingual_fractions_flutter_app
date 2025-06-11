import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _home();
}

class _home extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'FRACTIONS',
              style: GoogleFonts.comicNeue(
                fontSize: 85,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset(
              'assets/fraction_logo2.png',
              width: 880,
              height: 550,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
