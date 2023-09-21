import 'package:flutter/material.dart';
import 'package:education/screenAdmin/AddQuiz_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:education/models/quiz.dart';


class ListQuiz extends StatefulWidget {
  const ListQuiz({Key? key}) : super(key: key);

  @override
  _ListQuizState createState() => _ListQuizState();
}

class _ListQuizState extends State<ListQuiz> {
  List<Quiz> quizs = [];

  @override
  void initState() {
    super.initState();
    fetchQuizs();
  }

  Future<void> fetchQuizs() async {
  try {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/quizzes'),
      headers: {
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200 && response.body != null && response.body.isNotEmpty) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> jsonData = data['data'];
      final List<Quiz> fetchedQuizs = jsonData
      .map((item) => Quiz.fromJson(item))
      .toList();
      
      setState(() {
        quizs.clear();
        quizs.addAll(fetchedQuizs);
      });
    } else {
      throw Exception('Failed to load Quiz');
    }
    } catch (error) {
      print('Error fetching Quiz: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Liste des quiz',
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
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blueGrey, // Couleur du rectangle d'ajout
            padding: EdgeInsets.symmetric(vertical: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddQuiz(), // Redirige vers AddQuiz
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white, // Couleur de l'icône d'ajout
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Ajouter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Couleur du texte d'ajout
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16), // Espace entre le rectangle d'ajout et la liste
          Expanded(
            child: ListView.builder(
              itemCount: quizs.length,
              itemBuilder: (context, index) {
                final quiz = quizs[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(
                      quiz.question,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.remove_red_eye, // Icône "vue"
                            color: Colors.green, // Couleur de l'icône "vue"
                          ),
                          onPressed: () {
                            // Action lorsque l'icône "vue" est cliquée
                            // Vous pouvez définir l'action ici pour voir le quiz
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.orange, // Couleur de l'icône d'édition
                          ),
                          onPressed: () {
                            // Action lorsque l'icône de modification est cliquée
                            // Vous pouvez ouvrir la page de modification de quiz ici
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red, // Couleur de l'icône de suppression
                          ),
                          onPressed: () {
                            // Action lorsque l'icône de suppression est cliquée
                            // Vous pouvez supprimer le quiz de la liste ici
                            setState(() {
                              quizs.removeAt(index); // Correction ici
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
