import 'package:flutter/material.dart';
import 'matching_game.dart';
import 'apples_game.dart';

class Games extends StatelessWidget {
  const Games({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MatchingGame(),
    );
  }
}