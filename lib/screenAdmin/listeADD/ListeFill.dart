import 'package:flutter/material.dart';
import 'package:education/screenAdmin/Add_filiere.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:education/models/filiere.dart';

class ListFill extends StatefulWidget {
  const ListFill({Key? key}) : super(key: key);

  @override
  _ListFillState createState() => _ListFillState();
}

class _ListFillState extends State<ListFill> {
  List<String> filieres = [];

  @override
  void initState() {
    super.initState();
    fetchFilieres();
  }

  Future<void> fetchFilieres() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/filieres'),
        headers: {
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('data') && data['data'] is List<dynamic>) {
          final List<dynamic> filieresData = data['data'];
          final List<String> fetchedFilieres = filieresData
              .map((item) => item['libelle'].toString())
              .toList();

          setState(() {
            filieres.clear();
            filieres.addAll(fetchedFilieres);
          });
        } else {
          throw Exception('Failed to load filieres');
        }
      } else {
        throw Exception('Failed to load filieres');
      }
    } catch (error) {
      print('Error fetching filieres: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Liste des filières',
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
            color: Colors.blueGrey,
            padding: EdgeInsets.symmetric(vertical: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddFiliere(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Ajouter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filieres.length,
              itemBuilder: (context, index) {
                final filiere = filieres[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(
                      filiere,
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
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            // Action lorsque l'icône de modification est cliquée
                            // Vous pouvez ouvrir la page de modification de filière ici
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // Action lorsque l'icône de suppression est cliquée
                            // Vous pouvez supprimer la filière de la liste ici
                            setState(() {
                              filieres.removeAt(index);
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
