// questions_data.dart
import 'quiz_question.dart';

// questions_data.dart
final List<QuizQuestion> questions = [
  QuizQuestion(
    question: "What is fraction of the fruits are Apples?",
    imagePath: "assets/quiz/fruits1.png",
    answers: ["Three Eighth", "Five Eighth", "Five Thirds", "Three Fifth"],
    correctAnswerIndex: 1,
  ),

  QuizQuestion(
    question: "What is the ratio of Pink flowers to Orange flowers??",
    imagePath: "assets/quiz/flowers.png",
    answers: ["Three to Four", "Four to Seven", "None", "Four to Three"],
    correctAnswerIndex: 3,
    youtubeLink: "https://www.youtube.com/watch?v=EWLLHgTq1Ag",
  ),

  QuizQuestion(
    question: "How much pizza is this?",
    imagePath: "assets/quiz/Half-pizza.png",
    answers: ["Half", "One Third", "Two Third", "Whole"],
    correctAnswerIndex: 0, // Assuming "Half" is the correct answer
    youtubeLink: "https://www.youtube.com/watch?v=p33BYf1NDAE",
  ),
];
