import 'package:flutter/material.dart';
import 'matching_game.dart';

class games extends StatelessWidget {
  const games({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: matching_game(),
    );
  }
}