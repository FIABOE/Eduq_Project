class Question {
  String questionText;
  List<String> options;
  int correctAnswerIndices;
  String? selectedOption; // Ajoutez cet attribut pour enregistrer l'option sélectionnée

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndices,
    this.selectedOption, // Ajoutez cet attribut ici
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionText: json['question'],
      options: List<String>.from(json['options'].map((option) => option.toString().replaceAll("'", ''))),
      correctAnswerIndices: json['options'].indexWhere((option) => option == json['correct_option'].toString().replaceAll("'", '')),
    );
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}