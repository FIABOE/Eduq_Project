class Quiz {
  final String question;

  Quiz({required this.question});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      question: json['question'],
    );
  }
}