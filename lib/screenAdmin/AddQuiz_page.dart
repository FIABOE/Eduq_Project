import 'package:flutter/material.dart';
import 'package:education/screen/Info/list_filière.dart';
import 'package:education/screenAdmin/listeADD/ListQuiz.dart';
import 'package:education/screenAdmin/listeADD/ListeFill.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AddQuiz extends StatefulWidget {
  const AddQuiz({Key? key}) : super(key: key);

  @override
  _AddQuizState createState() => _AddQuizState();
}

class _AddQuizState extends State<AddQuiz> {
  TextEditingController questionController = TextEditingController();
  TextEditingController optionController = TextEditingController();
  TextEditingController correctAnswerController = TextEditingController();
  String selectedQuestionType = 'QCM'; // Par défaut, QCM est sélectionné
  String selectedFiliere = 'Filière '; // Remplacez par votre logique de sélection de filière
  bool isValiderButtonEnabled = false;

  void navigateToFiliereSelection() async {
    final selectedFiliere = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListFiliere(selectedFiliere: this.selectedFiliere),
      ),
    );

    if (selectedFiliere != null) {
      setState(() {
        this.selectedFiliere = selectedFiliere;
      });
    }
  }

  Future<void> ajouterQuiz() async {
  final String apiUrl = 'http://127.0.0.1:8000/api/quizzes';
  final List<String> options = optionController.text.split(',');
  final String correctOption = correctAnswerController.text;

  final Map<String, dynamic> formData = {
    'filiere_libelle': selectedFiliere,
    'question': questionController.text,
    'options': options, // Envoyez les options sous forme de tableau
    'correct_option': correctOption, // Utilisez la réponse correcte telle quelle
    'type_quiz': selectedQuestionType,
  };

  // Afficher les données avant l'envoi de la requête
  print('Données soumises : $formData');

  try {
    print('Envoi de la requête au serveur...');
    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(formData),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json', 
      },
    );

    print('Réponse du serveur : ${response.statusCode}');
    final responseBody = response.body;
    print('Réponse du serveur (corps) : $responseBody');

    if (response.statusCode == 201) {
      print('Quiz ajouté avec succès.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quiz ajouté avec succès.'),
          backgroundColor: const Color(0xFF70A19F),
        ),
      );
      // Réinitialisez les champs après l'ajout réussi.
      questionController.clear();
      optionController.clear();
      correctAnswerController.clear();
    } else {
      print('Échec de l\'ajout du quiz.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de l\'ajout du quiz.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (error) {
    print('Une erreur s\'est produite : $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Une erreur s\'est produite : $error'),
        backgroundColor: const Color(0xFF70A19F),
      ),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Ajouter un quiz',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF70A19F),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListQuiz(), // Redirige vers ListFill
                ),
              );
            },
            child: Row(
              children: [
                Icon(
                  Icons.list,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: navigateToFiliereSelection,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color.fromARGB(255, 204, 203, 203),
                    width: 2.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filière',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 17, 15, 15),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          selectedFiliere ?? 'Sélection',
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedFiliere != null ? const Color(0xFF087B95) : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: questionController,
              onChanged: (text) {
                setState(() {
                  isValiderButtonEnabled = text.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                labelText: 'Question',
                labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 17, 15, 15),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Arrondir les bords
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: optionController,
              onChanged: (text) {
                setState(() {
                  isValiderButtonEnabled = text.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                labelText: 'Option de réponse',
                labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 17, 15, 15),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Arrondir les bords
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: correctAnswerController,
              onChanged: (text) {
                setState(() {
                  isValiderButtonEnabled = text.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                labelText: 'Réponse correcte',
                labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 17, 15, 15),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Arrondir les bords
                ),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedQuestionType,
              onChanged: (newValue) {
                setState(() {
                  selectedQuestionType = newValue!;
                });
              },
              items: ['QCM', 'Vrai/Faux'] // Types de questions disponibles
              .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Type de question',
                labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 17, 15, 15),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Arrondir les bords
                ),
              ),
            ),
            SizedBox(height: 80),
            ElevatedButton(
              onPressed: isValiderButtonEnabled
      ? () {
          ajouterQuiz();
        }
      : null,
               style: ElevatedButton.styleFrom(
                primary: const Color(0xFF70A19F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Soumettre',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF0F0F0),
    );
  }
}
