// quiz_question.dart
class QuizQuestion {
  final String question;
  final List<String> imagePaths;
  final List<String> answers;
  final int correctAnswerIndex;
  final String? youtubeLink; // Optional field for YouTube link

  QuizQuestion({
    required this.question,
    required this.imagePaths,
    required this.answers,
    required this.correctAnswerIndex,
    this.youtubeLink, // This can be null, indicating no tutorial link is available
  });
}
