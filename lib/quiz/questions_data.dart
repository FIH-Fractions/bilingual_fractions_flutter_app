// questions_data.dart
import 'quiz_question.dart';

// questions_data.dart
final List<QuizQuestion> questions = [
  QuizQuestion(
    question: "How much pizza is this?",
    imagePath: "assets/quiz/Half-pizza.png",
    answers: ["Half", "One Third", "Two Third", "Whole"],
    correctAnswerIndex: 0, // Assuming "Half" is the correct answer
    youtubeLink: "https://www.youtube.com/watch?v=p33BYf1NDAE",
  ),

  QuizQuestion(
    question: "How much cake has been eaten?",
    imagePath: "assets/quiz/three_fourth_cake.png",
    answers: ["Three Fourth", "One Fourth", "Half", "None"],
    correctAnswerIndex: 1,
  ),
  // More questions...
];
