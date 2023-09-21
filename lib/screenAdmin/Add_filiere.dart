import 'package:flutter/material.dart';
import 'package:education/screenAdmin/listeADD/ListeFill.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddFiliere extends StatefulWidget {
  const AddFiliere({Key? key}) : super(key: key);

  @override
  _AddFiliereState createState() => _AddFiliereState();
}

class _AddFiliereState extends State<AddFiliere> {
  TextEditingController filiereController = TextEditingController();
  bool isValiderButtonEnabled = false;
  
  Future<void> ajouterFiliere(String filiere) async {
  final String apiUrl = 'http://127.0.0.1:8000/api/filieres';

  final Map<String, dynamic> formData = {
    'libelle': filiere,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: formData,
      headers: {
        'Accept': 'application/json', // En-tête pour indiquer le format attendu
      },
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Filière ajoutée avec succès.'),
          backgroundColor: const Color(0xFF70A19F),
        ),
      );
      // Réinitialisez le champ de filière après l'ajout réussi.
      filiereController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La filière.'),
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
          'Ajouter une filière',
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
                  builder: (context) => ListFill(), // Redirige vers ListFill
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
              controller: filiereController,
              onChanged: (text) {
                setState(() {
                  isValiderButtonEnabled = text.isNotEmpty;
                  
                });
              },
              decoration: InputDecoration(
                labelText: 'Renseigner la filière',
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
                ajouterFiliere(filiereController.text );
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
