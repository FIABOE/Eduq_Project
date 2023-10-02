import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:education/models/question.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizPage extends StatefulWidget {
  final int filiereId;

  QuizPage({Key? key, required this.filiereId}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  //Map<String, dynamic> userData = {};
  int _currentQuestionIndex = 0;
  double _progress = 0.0;
  String? userToken;
  List<Question> _questions = [];
  bool _questionsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadSavedState();
    _saveState();
    _fetchQuestions();
  }
  

  //Fonction chargement  la ou l'utilisateur s'est arrêté
  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedQuestionIndex = prefs.getInt('questionIndex');
    final savedProgress = prefs.getDouble('progress');

    setState(() {
      if (savedQuestionIndex != null) {
        _currentQuestionIndex = savedQuestionIndex;
      }
      if (savedProgress != null) {
        _progress = savedProgress;
      }
    });
  }
  //Fonction save la ou l'utilisateur s'est arrêté
  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('questionIndex', _currentQuestionIndex);
    prefs.setDouble('progress', _progress);
  }

  //fonction interaction avec BD pour récupérer les quiz
  Future<void> _fetchQuestions() async {
    print('Fetching questions for filiereId: ${widget.filiereId}');

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/quiz/${widget.filiereId}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
      );

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> jsonQuestions = jsonResponse['data'];

        final List<Question> questions = jsonQuestions.map((json) => Question.fromJson(json)).toList();

        setState(() {
          _questions = questions;
          _questionsLoaded = true;
        });

        print('Questions loaded successfully');
      } else {
        print('Failed to load questions: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur de chargement des questions'),
              content: Text('Une erreur s\'est produite lors du chargement des questions.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Fermer'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error fetching questions: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur de chargement des questions'),
            content: Text('Une erreur s\'est produite lors du chargement des questions.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Fermer'),
              ),
            ],
          );
        },
      );
    }
  }

  //Elle permet d'afficher les boite de résultat 
  void _onOptionSelected(String selectedOption) {
  final isCorrect = _questions[_currentQuestionIndex].options.indexOf(selectedOption) ==
      _questions[_currentQuestionIndex].correctAnswerIndices;

  if (isCorrect) {
    _showSuccessMessage();
  } else {
    _showFailureMessage();
  }

  setState(() {
    _questions[_currentQuestionIndex].selectedOption = selectedOption; // Ajoutez cette ligne pour enregistrer l'option sélectionnée
  });

  _nextQuestion();
  _saveState(); // Sauvegardez l'état après avoir répondu à une question
}


  //Pour la progression
  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _progress = (_currentQuestionIndex + 1) / _questions.length;
      } else {
        // Gérez le cas où toutes les questions ont été répondues
        // Vous pouvez afficher un message ou rediriger l'utilisateur vers une autre page, par exemple.
      }
    });
  }

  //Boite succès
  void _showSuccessMessage() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Bravo !',
          style: TextStyle(
            fontSize: 24, // Taille de la police
            fontWeight: FontWeight.bold, // Style de police en gras
            color: Colors.green, // Couleur du texte
          ),
        ),
        content: Text(
          'Bonne réponse !',
          style: TextStyle(
            fontSize: 18, // Taille de la police
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermer la boîte de dialogue
            },
            child: Text(
              'OK',
              style: TextStyle(
                fontSize: 18, // Taille de la police du bouton
                color: Colors.green, // Couleur du bouton
              ),
            ),
          ),
        ],
      );
    },
  );
}

//Boite Echec
void _showFailureMessage() {
  final correctAnswerIndex = _questions[_currentQuestionIndex].correctAnswerIndices;
  final correctAnswer = _questions[_currentQuestionIndex].options[correctAnswerIndex];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Dommage !',
          style: TextStyle(
            fontSize: 24, // Taille de la police
            fontWeight: FontWeight.bold, // Style de police en gras
            color: Colors.red, // Couleur du texte
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mauvaise réponse.',
              style: TextStyle(
                fontSize: 18, // Taille de la police
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Bonne réponse : $correctAnswer',
              style: TextStyle(
                fontSize: 18, // Taille de la police
                fontWeight: FontWeight.bold, // Style de police en gras
                color: Colors.green, // Couleur du texte
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermer la boîte de dialogue
            },
            child: Text(
              'OK',
              style: TextStyle(
                fontSize: 18, // Taille de la police du bouton
                color: Colors.red, // Couleur du bouton
              ),
            ),
          ),
        ],
      );
    },
  );
}


//l'interface proprement dite
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Filière',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF70A19F),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              // Gérer le menu de paramètres ici
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearPercentIndicator(
                    percent: _progress,
                    lineHeight: 10,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    backgroundColor: Colors.grey[300],
                    progressColor: Color(0xFF70A19F),
                  ),
                ),
                SizedBox(width: 8), // Espacement entre la barre de progression et l'échelle
                Text(
                  '${_currentQuestionIndex + 1} / ${_questions.length}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _questionsLoaded
                ? Column(
                    children: [
                      Text(
                        _currentQuestionIndex < _questions.length
                            ? _questions[_currentQuestionIndex].questionText
                            : 'Toutes les questions ont été répondues',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Column(
                        children: _questions[_currentQuestionIndex].options.map((option) {
                          final isCorrect = _questions[_currentQuestionIndex].options.indexOf(option) ==
                              _questions[_currentQuestionIndex].correctAnswerIndices;

                          final isSelected = option == _questions[_currentQuestionIndex].selectedOption;

                          // Déterminez la couleur de fond en fonction de la réponse sélectionnée
                          final backgroundColor = isSelected
                              ? isCorrect ? Colors.green : Colors.red
                              : Color(0xFF70A19F);

                          return GestureDetector(
                            onTap: () {
                              _onOptionSelected(option);
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: backgroundColor,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    option,
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }
}