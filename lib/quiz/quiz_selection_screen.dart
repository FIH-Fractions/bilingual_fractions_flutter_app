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

  bool isEnglish = true;

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
        title: Text(
          isEnglish ? 'Quizzes' : 'Cuestionarios',
          style: TextStyle(fontSize: 28),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(
                Icons.translate_rounded,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: () {
                setState(() {
                  isEnglish = !isEnglish;
                });
              },
              tooltip: isEnglish ? 'Cambiar a español' : 'Switch to English',
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              isEnglish
                  ? 'Select a quiz difficulty:'
                  : 'Selecciona una dificultad de cuestionario:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Total score display
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
                    isEnglish
                        ? 'Total Score: $totalScore points'
                        : 'Puntuación Total: $totalScore puntos',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            // Responsive quiz tiles
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return _buildResponsiveQuizLayout(constraints.maxWidth);
                },
              ),
            ),
            // Add some bottom spacing
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveQuizLayout(double screenWidth) {
    // Define breakpoints
    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth < 1000;
    bool isDesktop = screenWidth >= 1000;

    if (isMobile) {
      // Mobile: Stack tiles vertically
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildQuizTile(
                context,
                titleEn: 'Beginner',
                titleEs: 'Principiante',
                color: Colors.green.shade300,
                icon: Icons.star,
                score: quizScores[QuizCategory.beginner]!,
                category: QuizCategory.beginner,
                width: screenWidth * 0.8, // 80% of screen width
                height: 180,
              ),
              SizedBox(height: 16),
              _buildQuizTile(
                context,
                titleEn: 'Intermediate',
                titleEs: 'Intermedio',
                color: Colors.orange.shade300,
                icon: Icons.star_half,
                score: quizScores[QuizCategory.intermediate]!,
                category: QuizCategory.intermediate,
                width: screenWidth * 0.8,
                height: 180,
              ),
              SizedBox(height: 16),
              _buildQuizTile(
                context,
                titleEn: 'Advanced',
                titleEs: 'Avanzado',
                color: Colors.red.shade300,
                icon: Icons.star_border,
                score: quizScores[QuizCategory.advanced]!,
                category: QuizCategory.advanced,
                width: screenWidth * 0.8,
                height: 180,
              ),
            ],
          ),
        ),
      );
    } else if (isTablet) {
      // Tablet: Row with medium-sized tiles
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildQuizTile(
              context,
              titleEn: 'Beginner',
              titleEs: 'Principiante',
              color: Colors.green.shade300,
              icon: Icons.star,
              score: quizScores[QuizCategory.beginner]!,
              category: QuizCategory.beginner,
              width: (screenWidth - 64) / 3, // Divide by 3 with spacing
              height: 300,
            ),
            SizedBox(width: 16),
            _buildQuizTile(
              context,
              titleEn: 'Intermediate',
              titleEs: 'Intermedio',
              color: Colors.orange.shade300,
              icon: Icons.star_half,
              score: quizScores[QuizCategory.intermediate]!,
              category: QuizCategory.intermediate,
              width: (screenWidth - 64) / 3,
              height: 300,
            ),
            SizedBox(width: 16),
            _buildQuizTile(
              context,
              titleEn: 'Advanced',
              titleEs: 'Avanzado',
              color: Colors.red.shade300,
              icon: Icons.star_border,
              score: quizScores[QuizCategory.advanced]!,
              category: QuizCategory.advanced,
              width: (screenWidth - 64) / 3,
              height: 300,
            ),
          ],
        ),
      );
    } else {
      // Desktop: Row with max width and centered
      double maxTileWidth = 250;
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildQuizTile(
              context,
              titleEn: 'Beginner',
              titleEs: 'Principiante',
              color: Colors.green.shade300,
              icon: Icons.star,
              score: quizScores[QuizCategory.beginner]!,
              category: QuizCategory.beginner,
              width: maxTileWidth,
              height: 350,
            ),
            SizedBox(width: 24),
            _buildQuizTile(
              context,
              titleEn: 'Intermediate',
              titleEs: 'Intermedio',
              color: Colors.orange.shade300,
              icon: Icons.star_half,
              score: quizScores[QuizCategory.intermediate]!,
              category: QuizCategory.intermediate,
              width: maxTileWidth,
              height: 350,
            ),
            SizedBox(width: 24),
            _buildQuizTile(
              context,
              titleEn: 'Advanced',
              titleEs: 'Avanzado',
              color: Colors.red.shade300,
              icon: Icons.star_border,
              score: quizScores[QuizCategory.advanced]!,
              category: QuizCategory.advanced,
              width: maxTileWidth,
              height: 350,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildQuizTile(
    BuildContext context, {
    required String titleEn,
    required String titleEs,
    required Color color,
    required IconData icon,
    required int score,
    required QuizCategory category,
    required double width,
    required double height,
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
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(height: 16),
              Text(
                isEnglish ? titleEn : titleEs,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                isEnglish ? 'Score: $score' : 'Puntuación: $score',
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
