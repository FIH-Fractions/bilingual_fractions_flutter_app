// quiz_page.dart
import 'package:flutter/material.dart';
import 'quiz_question.dart';
import 'questions_data.dart';
import 'package:url_launcher/url_launcher.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  int _score = 0;
  // To track if the question has been answered, and if so, which option was selected
  int? _selectedAnswerIndex;

  void showTemporaryPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
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
          showTemporaryPopup('Your Answer is Correct! +10 points');
        } else {
          _score -= 5;
          showTemporaryPopup(
              'Wrong Answer! -5 points'); // Or you can customize this message
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz - Score: $_score'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Text(
                currentQuestion.question,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15.0),
              Image.asset(
                currentQuestion.imagePath,
                width: 500,
                height: 340,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 15.0), // Space above the answer row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: currentQuestion.answers.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String answer = entry.value;

                  // Determine button background color based on selection and correctness
                  Color backgroundColor = Color(0xFFF4F4DC); // Default color
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

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: idx == 0 ? 0 : 8,
                          right: idx == currentQuestion.answers.length - 1
                              ? 0
                              : 8),
                      child: ElevatedButton(
                        onPressed: () => _selectAnswer(idx),
                        child: Text(answer,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          primary: backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize:
                              Size(90, 80), // Minimum size of the button
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
                      child: Text('Back'),
                      style: ElevatedButton.styleFrom(
                        primary:
                            Color(0xFFF4F4DC), // Set the button color as needed
                        onPrimary: Colors.black, // Set the text color as needed
                      ),
                    ),
                  ElevatedButton(
                    onPressed: currentQuestion.youtubeLink != null
                        ? () async {
                            final url = currentQuestion.youtubeLink!;
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              // Handle the error or show a message if the URL can't be launched
                            }
                          }
                        : null, // Disables the button if there's no YouTube link
                    child: Text('Watch Tutorial'),
                    style: ElevatedButton.styleFrom(
                      primary:
                          Color(0xFFF4F4DC), // Set the button color as needed
                      onPrimary: Colors.black, // Set the text color as needed
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _selectedAnswerIndex != null &&
                            _currentIndex < questions.length - 1
                        ? _showNextQuestion
                        : null, // Disable the button if no answer is selected or if it's the last question
                    child: Text('Next'),
                    style: ElevatedButton.styleFrom(
                      primary:
                          Color(0xFFF4F4DC), // Set the button color as needed
                      onPrimary: Colors.black, // Set the text color as needed
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
}
