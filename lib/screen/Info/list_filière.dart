import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:education/models/filiere.dart';

class ListFiliere extends StatefulWidget {
  final String? selectedFiliere;

  const ListFiliere({Key? key, this.selectedFiliere}) : super(key: key);

  @override
  _ListFiliereState createState() => _ListFiliereState();
}

class _ListFiliereState extends State<ListFiliere> {
  List<String> filieres = [];
  List<String> filteredFilieres = [];
  TextEditingController searchController = TextEditingController();
  String? selectedFiliere;

  @override
  void initState() {
    super.initState();
    selectedFiliere = widget.selectedFiliere;
    fetchFilieres("", []);
  }

  Future<void> fetchFilieres(String query, List<String> filteredList) async {
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
              // Assurez-vous de mettre à jour également filteredFilieres pour afficher toutes les filières
              filteredFilieres.clear();
              filteredFilieres.addAll(filieres);
            });
          } else {
            throw Exception('Failed to load filieres');
          }
        } else {
      throw Exception('Failed to load filieres');
    }
  }
  // Modifier filterFilieres pour appeler fetchFilieres avec les paramètres
  void filterFilieres(String query) {
    // Assurez-vous de maintenir la liste complète des filières dans filteredFilieres au début.
    if (filteredFilieres.isEmpty) {
      setState(() {
        filteredFilieres.addAll(filieres);
      });
    }
    if (query.isEmpty) {
      setState(() {
        // Si la requête est vide, affichez à nouveau toutes les filières.
        filteredFilieres.clear();
        filteredFilieres.addAll(filieres);
      });
      } else {
        List<String> filteredList = filieres
        .where((filiere) =>
        filiere.toLowerCase().contains(query.toLowerCase()))
        .toList();
        setState(() {
          // Mettez à jour filteredFilieres avec les résultats de la recherche.
          filteredFilieres.clear();
          filteredFilieres.addAll(filteredList);
        });
      }
    }
    void selectFiliere(String filiere) {
      setState(() {
        selectedFiliere = filiere;
      });
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Filiere',
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
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (query) {
                      // Mise à jour du filtrage à chaque changement dans le texte.
                      filterFilieres(query);
                    },
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Rechercher une filière',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredFilieres.length,
                itemExtent: 70, 
                itemBuilder: (context, index) {
                  final filiere = filteredFilieres[index];
                  final isSelected = filiere == selectedFiliere;
                  return GestureDetector(
                    onTap: () {
                      final libelleFiliere = filiere;
                      selectFiliere(libelleFiliere);
                      Navigator.pop(context, libelleFiliere);
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        tileColor: isSelected ? Colors.grey.shade200 : Colors.white,
                        title: Text(
                          filiere,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.blue : Colors.black,
                          ),
                        ),
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
