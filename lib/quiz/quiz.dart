// quiz_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'quiz_question.dart';
import 'quiz_categories.dart';

class QuizPage extends StatefulWidget {
  final QuizCategory category;

  const QuizPage({Key? key, required this.category}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<QuizQuestion> questions;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _quizCompleted = false;
  int _correctAnswers = 0; // Track correct answers

  @override
  void initState() {
    super.initState();
    // Get questions for this category
    questions = getQuestionsByCategory(widget.category);
    _loadScore();
  }

  Future<void> _loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String scoreKey =
          '${widget.category.toString().split('.').last}_quiz_score';
      _score = prefs.getInt(scoreKey) ?? 0;
    });
  }

  Future<void> _saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    String scoreKey =
        '${widget.category.toString().split('.').last}_quiz_score';
    await prefs.setInt(scoreKey, _score);
  }

  void showTemporaryPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pop(true);
          }
        });
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNextQuestion() {
    setState(() {
      _selectedAnswerIndex = null; // Reset for the next question
      if (_currentIndex < questions.length - 1) {
        _currentIndex++;
      } else {
        _quizCompleted = true;
        _saveScore();
      }
    });
  }

  void _showPreviousQuestion() {
    setState(() {
      _selectedAnswerIndex = null; // Reset for navigating back
      if (_currentIndex > 0) {
        _currentIndex--;
      }
    });
  }

  void _selectAnswer(int index) {
    if (_selectedAnswerIndex == null) {
      // Prevent changing answer once selected
      setState(() {
        _selectedAnswerIndex = index;
        bool isCorrect = index == questions[_currentIndex].correctAnswerIndex;
        if (isCorrect) {
          _score += 10;
          _correctAnswers += 1; // Increment correct answers
          showTemporaryPopup('Your Answer is Correct! +10 points');
        } else {
          _score -= 5;
          showTemporaryPopup('Wrong Answer! -5 points');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If all questions are answered, show the completion screen
    if (_quizCompleted) {
      return _buildCompletionScreen();
    }

    final currentQuestion = questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title:
            Text('${getCategoryName(widget.category)} Quiz - Score: $_score'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Question ${_currentIndex + 1} of ${questions.length}',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  LinearProgressIndicator(
                    value: (_currentIndex + 1) / questions.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getProgressColor((_currentIndex + 1) / questions.length),
                    ),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    currentQuestion.question,
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: currentQuestion.imagePaths.map((imagePath) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.asset(
                          imagePath,
                          width: 240,
                          height: 340,
                          fit: BoxFit.contain,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 15.0), // Space above the answer row
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children:
                        currentQuestion.answers.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String answer = entry.value;

                      // Determine button background color based on selection and correctness
                      Color backgroundColor =
                          Color(0xFFF4F4DC); // Default color
                      if (_selectedAnswerIndex != null) {
                        if (idx == _selectedAnswerIndex) {
                          backgroundColor =
                              idx == currentQuestion.correctAnswerIndex
                                  ? Colors.green
                                  : Colors.red;
                        } else if (idx == currentQuestion.correctAnswerIndex) {
                          backgroundColor = Colors
                              .green; // Highlight correct answer if another answer was selected
                        } else {
                          backgroundColor = Colors
                              .grey; // Neutral color for unselected wrong answers
                        }
                      }

                      return Container(
                        width: MediaQuery.of(context).size.width / 2 - 25,
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        child: ElevatedButton(
                          onPressed: () => _selectAnswer(idx),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              answer,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      if (_currentIndex > 0)
                        ElevatedButton(
                          onPressed: _showPreviousQuestion,
                          child: Text('Previous'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8F87F1),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ElevatedButton(
                        onPressed: currentQuestion.youtubeLink != null
                            ? () async {
                                final url = currentQuestion.youtubeLink!;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                }
                              }
                            : null,
                        child: Text('Watch Tutorial'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8F87F1),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _selectedAnswerIndex != null
                            ? _showNextQuestion
                            : null,
                        child: Text(_currentIndex < questions.length - 1
                            ? 'Next'
                            : 'Finish'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8F87F1),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionScreen() {
    double percentageCorrect =
        questions.isEmpty ? 0 : (_correctAnswers / questions.length) * 100;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Completed'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                percentageCorrect >= 70 ? Icons.emoji_events : Icons.stars,
                size: 80,
                color: _getProgressColor(percentageCorrect / 100),
              ),
              SizedBox(height: 20),
              Text(
                'Quiz Completed!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Your Score: $_score points',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(height: 10),
              Text(
                '${percentageCorrect.toStringAsFixed(0)}% Correct',
                style: TextStyle(
                    fontSize: 22,
                    color: _getProgressColor(percentageCorrect / 100)),
              ),
              SizedBox(height: 30),
              Text(
                _getFeedbackMessage(percentageCorrect),
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Reset the quiz to try again
                      setState(() {
                        _currentIndex = 0;
                        _selectedAnswerIndex = null;
                        _quizCompleted = false;
                        _score = 0; // Reset score
                        _correctAnswers = 0; // Reset correct answers
                      });
                    },
                    child: Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Return to quiz selection with updated score
                      Navigator.pop(context, _score);
                    },
                    child: Text('Back to Quizzes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  if (_getNextCategory(widget.category) != null)
                    ElevatedButton(
                      onPressed: () {
                        final nextCategory = _getNextCategory(widget.category);
                        if (nextCategory != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuizPage(category: nextCategory),
                            ),
                          );
                        }
                      },
                      child: Text('Move to Next Level'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFeedbackMessage(double percentage) {
    if (percentage >= 90) {
      return 'Excellent! You have mastered these fractions!';
    } else if (percentage >= 70) {
      return 'Good job! You have a solid understanding of fractions!';
    } else if (percentage >= 50) {
      return 'Not bad! With a little more practice, you\'ll master fractions!';
    } else {
      return 'Keep practicing! Fractions can be tricky, but you\'ll get there!';
    }
  }

  Color _getProgressColor(double value) {
    if (value < 0.3) {
      return Colors.red;
    } else if (value < 0.7) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  QuizCategory? _getNextCategory(QuizCategory current) {
    final values = QuizCategory.values;
    final idx = values.indexOf(current);
    if (idx >= 0 && idx < values.length - 1) {
      return values[idx + 1];
    }
    return null;
  }
}
