import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FractionWritingGame extends StatefulWidget {
  const FractionWritingGame({super.key});

  @override
  State<FractionWritingGame> createState() => _FractionWritingGameState();
}

class FractionExample {
  final String fruitName;
  final String fullImagePath;
  final String partialImagePath;
  final String remainingFractionText;
  final String numerator;
  final String denominator;

  FractionExample({
    required this.fruitName,
    required this.fullImagePath,
    required this.partialImagePath,
    required this.remainingFractionText,
    required this.numerator,
    required this.denominator,
  });
}

final List<FractionExample> examples = [
  FractionExample(
    fruitName: 'kiwi',
    fullImagePath: 'assets/games/fullkiwi.png',
    partialImagePath: 'assets/games/halfkiwi.png',
    remainingFractionText: 'half',
    numerator: '1',
    denominator: '2',
  ),
  FractionExample(
    fruitName: 'orange',
    fullImagePath: 'assets/games/fullorange.png',
    partialImagePath: 'assets/games/onethirdorange.png',
    remainingFractionText: 'one third',
    numerator: '1',
    denominator: '3',
  ),
  FractionExample(
    fruitName: 'grapefruit',
    fullImagePath: 'assets/games/fullgrapefruit.png',
    partialImagePath: 'assets/games/34grapefruit.png',
    remainingFractionText: 'three fourths',
    numerator: '3',
    denominator: '4',
  ),
];

class _FractionWritingGameState extends State<FractionWritingGame> {
  bool showHalf = false;
  bool showQuestion = false;
  final TextEditingController numCtrl = TextEditingController();
  final TextEditingController denCtrl = TextEditingController();
  String feedback = '';
  int currentIndex = 0;
  FractionExample currentExample = examples[0];
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    currentExample = examples[currentIndex];
  }

  void checkAnswer() {
    final num = numCtrl.text.trim();
    final den = denCtrl.text.trim();

    final correct =
        num == currentExample.numerator && den == currentExample.denominator;

    setState(() {
      feedback = correct ? 'Correct!' : 'Try Again!';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(feedback),
        backgroundColor: correct ? Colors.green : Colors.red,
      ),
    );
  }

  void onKiwiTapped() {
    setState(() {
      showHalf = true;
      showQuestion = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Write Fractions",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: showHalf ? null : onKiwiTapped,
                child: Column(
                  children: [
                    Image.asset(
                      showHalf
                          ? currentExample.partialImagePath
                          : currentExample.fullImagePath,
                      height: 250,
                    ),
                    const SizedBox(height: 10),
                    if (!showHalf)
                      Text(
                        'Tap the ${currentExample.fruitName} to eat a fraction of it!',
                        style: const TextStyle(
                            fontSize: 20, fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (showQuestion) ...[
                Text(
                  'If you eat part of the ${currentExample.fruitName}, only ${currentExample.remainingFractionText} is left...',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      feedback == 'Correct!'
                          ? 'Learn how you would say the fraction:'
                          : 'How would you write it as a fraction?',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (feedback == 'Correct!')
                      IconButton(
                        icon: const Icon(Icons.volume_up_rounded),
                        iconSize: 28,
                        tooltip: 'Speak Fraction',
                        onPressed: () async {
                          await flutterTts
                              .speak(currentExample.remainingFractionText);
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 60,
                  child: Column(
                    children: [
                      TextField(
                        controller: numCtrl,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                      const Divider(thickness: 2),
                      TextField(
                        controller: denCtrl,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: checkAnswer,
                      child: const Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8F87F1),
                        foregroundColor: Colors.white,
                      ),
                    ),
                    if (feedback == 'Correct!' &&
                        currentIndex < examples.length - 1) ...[
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentIndex++;
                            currentExample = examples[currentIndex];
                            feedback = '';
                            numCtrl.clear();
                            denCtrl.clear();
                            showHalf = false;
                            showQuestion = false;
                          });
                        },
                        child: const Text('Next'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8F87F1),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
