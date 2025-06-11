import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz.dart';
import 'quiz_categories.dart';

class QuizSelectionScreen extends StatefulWidget {
  const QuizSelectionScreen({Key? key}) : super(key: key);

  @override
  _QuizSelectionScreenState createState() => _QuizSelectionScreenState();
}

class _QuizSelectionScreenState extends State<QuizSelectionScreen> {
  Map<QuizCategory, int> quizScores = {
    QuizCategory.beginner: 0,
    QuizCategory.intermediate: 0,
    QuizCategory.advanced: 0,
  };

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      quizScores[QuizCategory.beginner] =
          prefs.getInt('beginner_quiz_score') ?? 0;
      quizScores[QuizCategory.intermediate] =
          prefs.getInt('intermediate_quiz_score') ?? 0;
      quizScores[QuizCategory.advanced] =
          prefs.getInt('advanced_quiz_score') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total score
    int totalScore = quizScores.values.reduce((a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: Text('Quizzes', style: TextStyle(fontSize: 28)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              'Select a quiz difficulty:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Total score display as text
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events,
                      size: 32, color: Colors.blue.shade800),
                  SizedBox(width: 10),
                  Text(
                    'Total Score: $totalScore points',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Single row of quiz category tiles
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildQuizTile(
                      context,
                      title: 'Beginner',
                      color: Colors.green.shade300,
                      icon: Icons.star,
                      score: quizScores[QuizCategory.beginner]!,
                      category: QuizCategory.beginner,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildQuizTile(
                      context,
                      title: 'Intermediate',
                      color: Colors.orange.shade300,
                      icon: Icons.star_half,
                      score: quizScores[QuizCategory.intermediate]!,
                      category: QuizCategory.intermediate,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildQuizTile(
                      context,
                      title: 'Advanced',
                      color: Colors.red.shade300,
                      icon: Icons.star_border,
                      score: quizScores[QuizCategory.advanced]!,
                      category: QuizCategory.advanced,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizTile(
    BuildContext context, {
    required String title,
    required Color color,
    required IconData icon,
    required int score,
    required QuizCategory category,
  }) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage(category: category),
          ),
        );

        if (result != null && result is int) {
          setState(() {
            quizScores[category] = result;
          });
        }
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Score: $score',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
