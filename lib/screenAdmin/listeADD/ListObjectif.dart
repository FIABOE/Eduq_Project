import 'package:flutter/material.dart';
import 'package:education/screenAdmin/AddObjectif_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:education/models/filiere.dart';

class ListObjectif extends StatefulWidget {
  const ListObjectif({Key? key}) : super(key: key);

  @override
  _ListObjectifState createState() => _ListObjectifState();
}

class _ListObjectifState extends State<ListObjectif> {
  List<String> objectifs = [];

  @override
  void initState() {
    super.initState();
    fetchObjectifs();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Liste des objectifs',
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
                    builder: (context) => AddObjectif(), // Redirige vers AddQuiz
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
              itemCount: objectifs.length,
              itemBuilder: (context, index) {
                final objectif = objectifs[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(
                      objectif,
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
                            Icons.edit,
                            color: Colors.orange, // Couleur de l'icône d'édition
                          ),
                          onPressed: () {
                            // Action lorsque l'icône de modification est cliquée
                            // Vous pouvez ouvrir la page de modification de filière ici
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red, // Couleur de l'icône de suppression
                          ),
                          onPressed: () {
                            // Action lorsque l'icône de suppression est cliquée
                            // Vous pouvez supprimer la filière de la liste ici
                            setState(() {
                              objectifs.removeAt(index);
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
