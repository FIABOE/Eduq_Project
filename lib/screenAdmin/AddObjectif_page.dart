import 'package:flutter/material.dart';
import 'package:education/screenAdmin/listeADD/ListObjectif.dart';
import 'package:education/screenAdmin/listeADD/ListeFill.dart';
import 'package:http/http.dart' as http;

class AddObjectif extends StatefulWidget {
  const AddObjectif({Key? key}) : super(key: key);

  @override
  _AddObjectifState createState() => _AddObjectifState();
}

class _AddObjectifState extends State<AddObjectif> {
  TextEditingController objectifController = TextEditingController();
  bool isValiderButtonEnabled = false;

  Future<void> ajouterObjectif(String objectif) async {
  final String apiUrl = 'http://127.0.0.1:8000/api/objectifs';

  final Map<String, dynamic> formData = {
    'libelle': objectif,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: formData,
      headers: {
        'Accept': 'application/json', 
      },
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Objectif ajoutée avec succès.'),
          backgroundColor: const Color(0xFF70A19F),
        ),
      );
      // Réinitialisez le champ de l'Objectif après l'ajout réussi.
      objectifController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('L\'objectif existe déjà.'),
          backgroundColor: const Color(0xFF70A19F),
        ),
      );
    }
  } catch (error) {
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
        title: const Text(
          'Ajouter un objectif',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
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
                  builder: (context) => ListObjectif(), // Redirige vers ListFill
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
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            SizedBox(height: 30),
            TextField(
              controller: objectifController,
              onChanged: (text) {
                setState(() {
                  isValiderButtonEnabled = text.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                labelText: 'Renseigner l\'objectif',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFF70A19F)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 80),
            ElevatedButton(
              onPressed: isValiderButtonEnabled
              ? () {
                ajouterObjectif(objectifController.text);
              }
              : null,
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF70A19F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Soumettre',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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
