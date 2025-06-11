import 'quiz_question.dart';

enum QuizCategory {
  beginner,
  intermediate,
  advanced,
}

// Define questions for each category
final Map<QuizCategory, List<QuizQuestion>> categoryQuestions = {
  QuizCategory.beginner: [
    QuizQuestion(
      question: "What is fraction of the fruits are Apples?",
      imagePaths: ["assets/quiz/fruits1.png"],
      answers: ["Three Eighth", "Five Eighth", "Five Thirds", "Three Fifth"],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: "Which fraction is larger?",
      imagePaths: ["assets/quiz/int-pizza.png", "assets/quiz/int-pizza2.png"],
      answers: ["2/4", "1/2", "Both are equal", "Cannot determine"],
      correctAnswerIndex: 2,
    ),
  ],
  QuizCategory.intermediate: [
    QuizQuestion(
      question: "What is the ratio of Pink flowers to Orange flowers?",
      imagePaths: ["assets/quiz/flowers.png"],
      answers: ["Three to Four", "Four to Seven", "None", "Four to Three"],
      correctAnswerIndex: 3,
      youtubeLink: "https://www.youtube.com/watch?v=EWLLHgTq1Ag",
    ),
    QuizQuestion(
      question:
          "When comparing fractions with the same denominator, which one is greater?",
      imagePaths: ["assets/quiz/orange.png", "assets/quiz/orange2.png"],
      answers: [
        "The one with smaller numerator",
        "The one with larger numerator",
        "They are equal",
        "Cannot determine"
      ],
      correctAnswerIndex: 1,
    ),
  ],
  QuizCategory.advanced: [
    QuizQuestion(
      question: "What is 3/4 - 1/4?",
      imagePaths: [],
      answers: ["2/4", "1/2", "1/4", "2/8"],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question: "Which fraction is equivalent to 2/4?",
      imagePaths: [],
      answers: ["1/2", "3/6", "4/8", "All of these"],
      correctAnswerIndex: 3,
    ),
  ],
};

// Get questions by category
List<QuizQuestion> getQuestionsByCategory(QuizCategory category) {
  return categoryQuestions[category] ?? [];
}

// Category names for display
String getCategoryName(QuizCategory category) {
  switch (category) {
    case QuizCategory.beginner:
      return 'Beginner';
    case QuizCategory.intermediate:
      return 'Intermediate';
    case QuizCategory.advanced:
      return 'Advanced';
    default:
      return '';
  }
}
