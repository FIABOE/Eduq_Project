import 'package:flutter/material.dart';
import 'package:education/screen/Profil/avatar.dart';
import '../Homepage/accueil_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoitePage extends StatefulWidget {
  const BoitePage({Key? key}) : super(key: key);

  @override
  _BoitePageState createState() => _BoitePageState();
}

class _BoitePageState extends State<BoitePage> {
  int _selectedIndex = 0;
  String avatarPath = '';
  String pseudo = '';
  bool avatarSelected = false;
  bool isAvatarSelected = false;
  String? userToken;
  TextEditingController _pseudoController = TextEditingController();
  
  Future<void> _getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('userToken');
    //print('Token d\'authentification récupéré depuis les préférences : $userToken');
  }
  
  //convertion de l'image
  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');
    String pt = path.split('/')[2];
    final buffer = byteData.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = '$tempPath/$pt'; 
    return File(filePath)
    .writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }

  //fonction pour gestion de profil
  Future<void> userProfile(String pseudo, String avatarPath) async {
  try {
    var request = http.MultipartRequest(
      'POST', 
      Uri.parse('http://127.0.0.1:8000/api/profil'),
    );
    
    // Ajouter l'en-tête Authorization avec le token de l'utilisateur
      request.headers['Authorization'] = 'Bearer $userToken'; // Remplacez $userToken par le vrai token de l'utilisateur
      request.headers['Accept'] = 'application/json';

      request.fields['pseudo'] = pseudo;
      
      if (avatarPath.isNotEmpty) {
        var file = await getImageFileFromAssets(avatarPath);
        var avatar = await http.MultipartFile.fromPath('avatar', (await file).path); // Attendre la résolution de la future
        request.files.add(avatar);
      }
      
      //print('Demande envoyée : ${request.fields}');
      var response = await request.send();

      var responseStream = await response.stream.transform(utf8.decoder).toList();
      var responseBody = responseStream.join();
      //print('Réponse brute du serveur : $responseBody'); 

      var jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccueilPage(),
          ),
        );
      } else {
        //print('Échec de la mise à jour du profil.');
        //print('Réponse du serveur : $jsonResponse');
      }
    } catch (e) {
      //print('Une erreur est survenue lors de la mise à jour du profil : $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      avatarPath = prefs.getString('avatarPath') ?? '';
      //print('Avatar Path: $avatarPath');
      setState(() {});
      // Afficher la boîte de dialogue dès que la page est prête
      _showDialog(context);
    });
    _getUserToken();
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Veuillez choisir votre pseudo et votre avatar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Color.fromARGB(255, 252, 252, 252),
                          child: avatarPath.isEmpty
                          ? Icon(
                            Icons.person,
                              size: 24,
                              color: Color.fromARGB(255, 248, 91, 91),
                            )
                          : ClipOval(
                            child: Image.asset(
                                avatarPath,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 24,
                          color: Colors.orange,
                        ),
                        onPressed: () async {
                          final selectedAvatar = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AvatarPage(),
                            ),
                          ) as String?;
                          if (selectedAvatar != null) {
                            setState(() {
                              // Mettez à jour l'avatar affiché dans la boîte de dialogue
                              avatarPath = selectedAvatar;
                            });
                            // Enregistrez également le chemin de l'avatar dans SharedPreferences
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            prefs.setString('avatarPath', selectedAvatar);
                          }
                          //print('Affiche: $selectedAvatar');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pseudo: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _pseudoController,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 143, 69, 9),
                              fontSize: 18,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              hintText: 'Mettez votre pseudo',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            //onChanged: (value) {
                              // Mettre à jour le pseudo lorsque l'utilisateur tape un nouveau pseudo
                              // ...
                            //},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text(
                      'Valider',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF70A19F),
                    ),
                    onPressed: () async {
                      final pseudo = _pseudoController.text;
                      await userProfile(pseudo, avatarPath);
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF70A19F),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'D-Academy',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      //body: Center(
        //child: ElevatedButton(
          //onPressed: () {
            // Vous pouvez retirer ce bouton si vous voulez afficher la boîte de dialogue automatiquement
            //_showDialog(context);
          //},
          //child: const Text('Afficher le dialogue'),
        //),
      //),
    );
  }
}


