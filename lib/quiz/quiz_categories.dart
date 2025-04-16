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
      imagePath: "assets/quiz/fruits1.png",
      answers: ["Three Eighth", "Five Eighth", "Five Thirds", "Three Fifth"],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: "What is the ratio of Pink flowers to Orange flowers?",
      imagePath: "assets/quiz/flowers.png",
      answers: ["Three to Four", "Four to Seven", "None", "Four to Three"],
      correctAnswerIndex: 3,
      youtubeLink: "https://www.youtube.com/watch?v=EWLLHgTq1Ag",
    ),
    QuizQuestion(
      question: "How much pizza is this?",
      imagePath: "assets/quiz/Half-pizza.png",
      answers: ["Half", "One Third", "Two Third", "Whole"],
      correctAnswerIndex: 0,
      youtubeLink: "https://www.youtube.com/watch?v=p33BYf1NDAE",
    ),
    QuizQuestion(
      question: "What fraction of the circle is shaded?",
      imagePath: "assets/quiz/quarter_circle.png",
      answers: ["One Quarter", "One Third", "One Half", "Three Quarters"],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question:
          "If you eat 2 slices of a pizza cut into 8 equal slices, what fraction did you eat?",
      imagePath: "assets/quiz/pizza_slices.png",
      answers: ["2/8", "1/4", "Both A and B", "None of these"],
      correctAnswerIndex: 2,
    ),
  ],
  QuizCategory.intermediate: [
    QuizQuestion(
      question: "What is 1/4 + 1/4?",
      imagePath: "assets/quiz/addition.png",
      answers: ["2/4", "1/2", "2/8", "1/8"],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: "What is 3/4 - 1/4?",
      imagePath: "assets/quiz/subtraction.png",
      answers: ["2/4", "1/2", "1/4", "2/8"],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question: "Which fraction is equivalent to 2/4?",
      imagePath: "assets/quiz/equivalent.png",
      answers: ["1/2", "3/6", "4/8", "All of these"],
      correctAnswerIndex: 3,
    ),
    QuizQuestion(
      question:
          "When comparing fractions with the same denominator, which one is greater?",
      imagePath: "assets/quiz/comparing.png",
      answers: [
        "The one with smaller numerator",
        "The one with larger numerator",
        "They are equal",
        "Cannot determine"
      ],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: "What is the mixed number for 7/4?",
      imagePath: "assets/quiz/mixed_number.png",
      answers: ["1 3/4", "3 1/4", "1 3/7", "4 3/7"],
      correctAnswerIndex: 0,
    ),
  ],
  QuizCategory.advanced: [
    QuizQuestion(
      question: "What is 2/3 × 3/4?",
      imagePath: "assets/quiz/multiplication.png",
      answers: ["6/12", "1/2", "5/12", "2/12"],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: "What is 3/4 ÷ 1/2?",
      imagePath: "assets/quiz/division.png",
      answers: ["3/2", "6/4", "1.5", "All of these"],
      correctAnswerIndex: 3,
    ),
    QuizQuestion(
      question:
          "If 3/5 of students in a class are girls, what fraction are boys?",
      imagePath: "assets/quiz/boys_girls.png",
      answers: ["2/5", "3/8", "2/3", "5/3"],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question: "Which is the smallest fraction?",
      imagePath: "assets/quiz/comparing_complex.png",
      answers: ["3/8", "2/5", "5/12", "1/3"],
      correctAnswerIndex: 3,
    ),
    QuizQuestion(
      question:
          "If a recipe needs 3/4 cup of flour, how much is needed to make 1/3 of the recipe?",
      imagePath: "assets/quiz/recipe.png",
      answers: ["1/4 cup", "1/12 cup", "1/4 cup", "3/12 cup"],
      correctAnswerIndex: 0,
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
