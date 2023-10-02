import 'package:flutter/material.dart';
import 'package:education/screen/Info/mes_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ObjectifPage extends StatefulWidget {
  const ObjectifPage({Key? key}) : super(key: key);

  @override
  _ObjectifPageState createState() => _ObjectifPageState();
}

class _ObjectifPageState extends State<ObjectifPage> {
  List<String> objectifs = [];
  String? selectedObjectif;
  String? userToken;

  IconData icon = Icons.hourglass_full; // Utilisez l'icône par défaut
  Color color = Color(0xFF70A19F); // Utilisez la couleur par défaut

  @override
  void initState() {
    super.initState();
    fetchObjectifs();
    _getUserToken();
  }

  Future<void> fetchObjectifs() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/objectifs'),
        headers: {
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('data') && data['data'] is List<dynamic>) {
          final List<dynamic> objectifsData = data['data'];
          final List<String> fetchedObjectifs = objectifsData
              .map((item) => item['libelle'].toString())
              .toList();

          setState(() {
            objectifs.clear();
            objectifs.addAll(fetchedObjectifs);
          });
        } else {
          throw Exception('Failed to load objectifs');
        }
      } else {
        throw Exception('Failed to load objectifs');
      }
    } catch (error) {
      print('Error fetching objectifs: $error');
    }
  }

  Future<void> _getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('userToken');
    //print('Token d\'authentification récupéré depuis les préférences : $userToken');
  }

  Future<void> _saveObjectif(String selectedObjectif) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/choisir-objectif'); 
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    };
    final body = {
      'selected_objectif': selectedObjectif,
    };
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text(
              'Objectif enregistré avec succès.',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold, 
                color: Colors.white, 
              ),
            ),
            backgroundColor: Color(0xFF70A19F), 
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MesinfoPage()),
        );  
        } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erreur lors de l\'enregistrement de l\'objectif',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold, 
                color: Colors.white, 
              ),   
            ),
            backgroundColor: Color(0xFFF5804E), 
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erreur lors de la requête. Veuillez réessayer.',
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold, 
              color: Colors.white, 
            ), 
          ),
          backgroundColor: Color(0xFFFC6161), 
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
            'D-Academy',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: color, // Utilisez la couleur personnalisée
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30, // Ajuster la taille de l'icone
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Quel est votre objectif ?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF087B95),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: objectifs.length,
              itemBuilder: (context, index) {
                final objectifItem = objectifs[index];
                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      selectedObjectif = objectifItem; // Sélectionnez l'objectif ici
                    });
                    _saveObjectif(selectedObjectif!); // Enregistrez l'objectif lorsque la carte est cliquée
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: color, // Utilisez la couleur personnalisée
                      border: Border.all(
                        color: color, // Utilisez la couleur personnalisée
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.6), // Utilisez la couleur personnalisée
                          blurRadius: 10,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            color: color.withOpacity(0.2), // Utilisez la couleur personnalisée
                          ),
                          child: Icon(
                            icon,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  objectifItem,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white, // Texte en blanc pour une meilleure lisibilité
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '', // Ajoutez ici la description si nécessaire
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey, // Texte en gris pour une meilleure lisibilité
                                  ),
                                ),
                              ],
                            ),
                          ),
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
