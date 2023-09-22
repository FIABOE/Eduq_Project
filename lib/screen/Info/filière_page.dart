import 'package:education/screen/Info/list_filière.dart';
import 'package:education/screen/Info/objectif_page.dart';
import 'package:education/screen/Info/intro_page.dart';
import 'package:education/models/filiere.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FilierePage extends StatefulWidget {
  const FilierePage({Key? key}) : super(key: key);

  @override
  _FilierePageState createState() => _FilierePageState();
}

class _FilierePageState extends State<FilierePage> {
  String? selectedFiliere;
  bool isButtonEnabled = false;
  String? userToken;


  @override
  void initState() {
    super.initState();
    _getUserToken();
  }
  
  Future<void> _getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('userToken');
    print('Token d\'authentification récupéré depuis les préférences : $userToken');
  }

  void _navigateToListFilierePage() async {
    final selectedFiliere = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListFiliere(selectedFiliere: this.selectedFiliere)),
    );
    if (selectedFiliere != null) {
      setState(() {
        this.selectedFiliere = selectedFiliere;
        isButtonEnabled = true;
      });
    }
  }

  Future<void> _saveFiliere() async {
    if (selectedFiliere != null) {
      final url = Uri.parse('http://127.0.0.1:8000/api/choisir-filiere');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $userToken',
      };
      final body = ({
        'selected_filiere': selectedFiliere,
      });
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
              'Filière enregistrée avec succès.',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold, 
                color: Colors.white, 
              ),
            ),
            backgroundColor: Color(0xFF70A19F)
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ObjectifPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
            'Erreur lors de l\'enregistrement de la filière.',
            style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold, 
                color: Colors.white, 
              ),
            ),
            backgroundColor: Color(0xFFEE7E23)
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
          backgroundColor: Color(0xFFEE592C)
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'D-Academy',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF70A19F),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => IntroPage()), 
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Choisissez votre filière ?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF087B95),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _navigateToListFilierePage,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            const Spacer(),
            SizedBox(
              width: 400.0,
              height: 45,
              child: ElevatedButton(
                onPressed: isButtonEnabled ? _saveFiliere : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: isButtonEnabled ? const Color(0xFF70A19F) : Colors.grey,
                ),
                child: const Text(
                  'Soumettre',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
   