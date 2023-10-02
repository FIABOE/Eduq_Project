import 'package:flutter/material.dart';
import 'package:education/screenAdmin/adAccueil_page.dart';
import 'package:http/http.dart' as http;
import 'package:education/models/user.dart';
import 'package:education/models/moderateur.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ListMod extends StatefulWidget {
  const ListMod({Key? key}) : super(key: key);

  @override
  _ListModState createState() => _ListModState();
}

class _ListModState extends State<ListMod> {
  List<Moderateur> moderateurs = [];
  List<bool> isCheckedList = [];
   String? userToken;

  @override
  void initState() {
    super.initState();
    fetchModerateurs();
    _getUserToken();
  }

  Future<void> _getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('userToken');
    //print('Token d\'authentification récupéré depuis les préférences : $userToken');
  }

  Future<void> fetchModerateurs() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/moderators'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
      );
      
      //print('Response status code: ${response.statusCode}');
      //print('Response body: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('success') && data['success'] == true) {
          final List<dynamic> moderateursData = data['moderators'];
          final List<Moderateur> fetchedModerateurs = moderateursData.map((item) {
            final id = item['id'];

            if (id is int) {
              return Moderateur(id: id, name: item['Nom'].toString());
            } else if (id is String) {
              return Moderateur(id: int.tryParse(id) ?? 0, name: item['Nom'].toString());
            } else {
            // Gérer le cas où id est null ou d'un type inattendu
              return Moderateur(id: 0, name: item['Nom'].toString());
            }
          }).toList();

          setState(() {
            moderateurs.clear();
            moderateurs.addAll(fetchedModerateurs);
            isCheckedList = List.generate(moderateurs.length, (index) => false);
          });
        } else {
        throw Exception('Failed to load Mod');
        }
      } else {
        throw Exception('Failed to load fMod');
      }
    } catch (error) {
      print('Error fetching Mod: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liste des modérateurs',
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
                    builder: (context) => AdAccueilPage(),
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
              itemCount: moderateurs.length,
              itemBuilder: (context, index) {
                final moderateur = moderateurs[index];

                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(
                      moderateur.name,
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
                            Icons.remove_red_eye,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            // Action lorsque l'icône "vue" est cliquée
                            // Vous pouvez définir l'action ici pour voir le modérateur
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            // Action lorsque l'icône de modification est cliquée
                            // Vous pouvez ouvrir la page de modification du modérateur ici
                          },
                        ),
                        Checkbox(
                          value: isCheckedList[index],
                          onChanged: (newValue) {
                            // Action lorsque la case à cocher est activée ou désactivée
                            setState(() {
                              isCheckedList[index] = newValue ?? false;
                              // Mettez à jour l'état de la case à cocher dans la liste principale ici
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
