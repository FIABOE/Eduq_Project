import 'package:flutter/material.dart';
import 'package:education/screen/Quiz/quiz_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Architecture extends StatefulWidget {
  const Architecture({Key? key}) : super(key: key);

  @override
  _ArchitectureState createState() => _ArchitectureState();
}

class _ArchitectureState extends State<Architecture> {
  Map<String, dynamic> userData = {};
  String? userToken;
  //int selectedFiliereId = 0;

  final List<String> coursList = ['Fonctionnement'];

  // Pour récupérer la filière choisie
  Widget buildFiliereWidget() {
    if (userData['Filiere'] != null) {
      return Text(
        userData['Filiere'],
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      );
    } else {
      // Message d'erreur si la filière est nulle.
      return Text(
        '',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchUserDat();
  }

  //Récupérer libelle filiere
  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('userToken');

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/user'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final user = data['user'];

      if (user.containsKey('Filiere')) {
        setState(() {
          userData = {
            'Filiere': user['Filiere'],
          };
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Erreur de chargement des données',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Une erreur s\'est produite lors du chargement des données de l\'utilisateur.',
              style: TextStyle(fontSize: 18),
            ),
            backgroundColor: Color(0xFFF5804E),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Fermer',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ],
          );
        },
      );
    }
  }
  //Recupérer id filliere
  Future<void> fetchUserDat() async {
  final prefs = await SharedPreferences.getInstance();
  userToken = prefs.getString('userToken');

  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/api/user'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final user = data['user'];

    if (user.containsKey('filiere_id')) { 
      setState(() {
        userData['FiliereId'] = user['filiere_id'];
      });
    }
  } else {
    // Gérez l'erreur en conséquence
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Erreur de chargement des données',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Une erreur s\'est produite lors du chargement des données de l\'utilisateur.',
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: Color(0xFFF5804E),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Fermer',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildFiliereWidget(),
        centerTitle: true,
        backgroundColor: const Color(0xFF70A19F),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            // Carte "Quiz" avec liste des quiz
            _buildQuizCard(),
            const SizedBox(height: 0.0),
            // Liste déroulante pour "Cours"
            _buildSection('Cours', coursList, Icons.book, Colors.orange, Colors.orangeAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          // Redirigez vers la page de quiz (ou où vous le souhaitez)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(filiereId: userData['FiliereId']),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.quiz,
                color: Colors.blue,
                size: 40,
              ),
              const SizedBox(width: 16),
              Text(
                'Quiz',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items, IconData icon, Color color, Color hoverColor) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ExpansionTile(
        leading: Icon(
          icon,
          color: color,
          size: 40,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        children: items.map((item) => _buildItem(item, hoverColor)).toList(),
      ),
    );
  }

  Widget _buildItem(String item, Color hoverColor) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(item),
        hoverColor: hoverColor,
        onTap: () {
          // Ajoutez le code pour rediriger vers la page de cours correspondante
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => YourCoursePage(), // Remplacez YourCoursePage par la page de cours souhaitée
          //   ),
          // );
        },
      ),
    );
  }
}
