import 'package:flutter/material.dart';
import '../Compte/compte_page.dart';
import 'package:education/screen/Quiz/revision_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({Key? key}) : super(key: key);

  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {

  int _selectedIndex = 0; 
  double progression = 0.2;

  List<IconData> badgeIcons = [
    Icons.bookmark,
    Icons.star,
    Icons.label,
  ];

  String pseudo = ''; 
  String avatarUrl = ''; 
  String avatarFileName = '';
  bool isListVisible = false;
  List<String> objectifs = [];
  String? selectedObjectif;
  String? userToken;
  Map<String, dynamic> userData = {};


  //convertion des minutes
  String _extractDuration(String objectif) {
  String duree = objectif.replaceAll(RegExp(r'[^0-9h]+'), ''); // Supprime tous les caractères sauf les chiffres, 'h' et 'min'
    duree = duree.replaceAll('h', ' h '); // Ajoute des espaces autour de 'h' pour faciliter la séparation
    duree = duree.replaceAll('min', ' min '); // Ajoute des espaces autour de 'min' pour faciliter la séparation
    return duree.trim(); // Supprime les espaces supplémentaires aux extrémités
  }

  //Récupération de la filiere
  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('userToken'); 
    //print('authentification: $userToken');
    
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
      print('utilisateur: $user');
      
      if (user.containsKey('Objectif hebdomadaire')) {
        setState(() {
          userData = {
            'Objectif hebdomadaire': user['Objectif hebdomadaire'],
          };
          print('Objectif hebdomadaire récupérée avec succès : ${userData['Objectif hebdomadaire']}');
        });
      } else {
        print("La clé 'Objectif hebdomadaire' n'est pas présente dans les données de l'utilisateur.");
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

   @override
   void initState() {
    super.initState();
    fetchUserProfile();
    fetchUserData();
    fetchObjectifs();
  }

  
//gestion pour afficher l'objectif
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
          MaterialPageRoute(builder: (context) => AccueilPage()),
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
  
  Widget buildObjectifTile(String objectif) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16), // Ajustez les marges
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8), // Ajustez le rayon de la bordure
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          objectif,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Couleur du texte
          ),
        ),
        tileColor: Colors.transparent, // Couleur de fond transparente
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Ajustez le padding
        onTap: () {
          setState(() {
            selectedObjectif = objectif;
          });
          _saveObjectif(selectedObjectif!);
        },
        trailing: Icon(
          Icons.check, // Icône de sélection (vous pouvez changer cela)
          color: Colors.green, // Couleur de l'icône de sélection
        ),
      ),
    );
  }

  //fonction qui traite le profil du user
  Future<void> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('userToken'); 
    print('authentification: $userToken');
    try {
    print('Début de la requête HTTP');
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/user/profile'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
    );

    print('Réponse HTTP reçue');

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('success') && data['success'] == true) {
        // Récupérez le pseudo et l'URL de l'avatar depuis les données du profil
        final String userPseudo = data['pseudo'];
        final String userAvatarUrl = data['avatar'];

        print('Pseudo récupéré : $userPseudo');
        print('URL de l\'avatar récupéré : $userAvatarUrl');

        setState(() {
          pseudo = userPseudo; // Mettez à jour le pseudo dans l'état local
          avatarUrl = userAvatarUrl; // Mettez à jour l'URL de l'avatar dans l'état local
          updateAvatarFileName(userAvatarUrl);
        });

        print('Mise à jour de l\'état local effectuée');
      }
    }
  } catch (error) {
    print('Erreur lors de la récupération du profil utilisateur : $error');
  }
}

 // Fonction pour extraire le nom du fichier d'avatar de l'URL
  void updateAvatarFileName(String url) {
    final List<String> urlSegments = url.split('/');
    avatarFileName = urlSegments.isNotEmpty ? urlSegments.last : '';
  }

  // Fonction pour construire le chemin complet vers l'image d'avatar
  String buildAvatarImagePath() {
    return 'assets/images/$avatarFileName';
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
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ComptePage()),
              );
            },
            child: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(buildAvatarImagePath()),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    decoration: const BoxDecoration(
                      color: const Color(0xFF70A19F),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenue $pseudo',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Découvrez un monde d\'apprentissage interactif et amusant',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                       const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           ElevatedButton(
                            onPressed: () {
                            },
                            child: const Text(
                              'Me tester',
                              style: TextStyle(
                                color: Color.fromARGB(255, 253, 253, 253), 
                                fontSize: 16, 
                                fontWeight: FontWeight.bold, // Mettre le texte en gras si nécessaire
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 252, 202, 145), // Changer la couleur du bouton en vert
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5), // Arrondir les bords du bouton avec un rayon de 5
                              ),
                            ),
                          ),
                            const Text(
                              'En savoir plus',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 254), // Changer la couleur du texte en bleu
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[100], // Couleur de fond du cadre
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Objectifs hebdomadaires',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                               CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isListVisible = !isListVisible;
                                      });
                                    },
                                  ),
                               ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Stack(
                              children: [
                                Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: progression,
                                  child: Container(
                                    height: 10,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 66, 146, 73),
                                          Color.fromARGB(255, 70, 206, 131),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              height: isListVisible ? 200 : 0,
                              child: isListVisible
                              ? ListView.builder(
                                itemCount: objectifs.length,
                                itemBuilder: (context, index) {
                                  return buildObjectifTile(objectifs[index]);
                                },
                              )
                            : null,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '2 min',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 248, 232, 5),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  userData['Objectif hebdomadaire'] != null
                                  ? '${_extractDuration(userData['Objectif hebdomadaire'])} min'
                                  : '',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 248, 232, 5),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[100],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ma bibliothèque',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 20),
                          GridView.count(
                            crossAxisCount: 3, // Nombre de cartes par ligne
                            crossAxisSpacing:5, // Espacement horizontal réduit entre les cartes
                            mainAxisSpacing:5, // Espacement vertical réduit entre les cartes
                            childAspectRatio:0.8, // Rapport largeur/hauteur des cartes
                            shrinkWrap:
                                true, // Ajuste la hauteur de GridView en fonction du contenu
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RevisionPage()), // Remplacez `RevisionPage()` par le constructeur correct si nécessaire
                                  );
                                },
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[100],
                                    ),
                                    padding: const EdgeInsets.all(16.0),
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.fitness_center,
                                          size: 40,
                                          color: Colors.orange,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Exercices',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        // Ajoutez ici le contenu de la carte des exercices
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[100],
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.school,
                                        size: 40,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Examens',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                        // Ajoutez ici le contenu de la carte des examens
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[100],
                                      ),
                                      padding: const EdgeInsets.all(16.0),
                                      child: const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.book,
                                            size: 40,
                                            color: Colors.green,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Fiches',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                          ),
                                            //  Ajoutez ici le contenu de la carte des fiches
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[100],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Badges',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: badgeIcons.map((icon) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(icon, color: Colors.grey),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),        
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kiosque',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Accéder au kiosque',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '>',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange, // Couleur souhaitée
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 200,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                    // Ajoutez ici l'image de la première carte (partie supérieure)
                                    color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Texte première',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                            // Ajoutez ici le contenu de la première carte (partie inférieure)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: SizedBox(
                          height: 200,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),  
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                // Ajoutez ici l'image de la deuxième carte (partie supérieure)
                                //color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Texte deuxième',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                    // Ajoutez ici le contenu de la deuxième carte (partie inférieure)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[100],
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                              // Ajoutez ici l'image de la troisième carte (partie supérieure)
                              color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Texte troisième',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                      // Ajoutez ici le contenu de la troisième carte (partie inférieure)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[100],
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                // Ajoutez ici l'image de la quatrième carte (partie supérieure)
                              color: Colors.yellow,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Texte quatrième',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                    // Ajoutez ici le contenu de la quatrième carte (partie inférieure)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 7),
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                        // Action lorsque le bouton est pressé
                },
                child: const Text(
                  "S'orienter",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 10, 134, 103),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  shadowColor: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
       ),
       child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: _selectedIndex == 0 ? Colors.blue : Colors.grey),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AccueilPage()),
                  );
                },
              ),
              Text('Accueil', style: TextStyle(color: _selectedIndex == 0 ? Colors.blue : Colors.grey)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.library_books, color: _selectedIndex == 1 ? Colors.green : Colors.grey),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RevisionPage()),
                  );
                },
              ),
              Text('Révision', style: TextStyle(color: _selectedIndex == 1 ? Colors.green : Colors.grey)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.emoji_events, color: _selectedIndex == 2 ? Colors.orange : Colors.grey),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                          // Action pour l'icône de tournoi
                },
              ),
              Text('Tournoi', style: TextStyle(color: _selectedIndex == 2 ? Colors.orange : Colors.grey)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.star, color: _selectedIndex == 3 ? Colors.purple : Colors.grey),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 3;
                  });       // Action pour l'icône de profil
                },
              ),
              Text('Premium', style: TextStyle(color: _selectedIndex == 3 ? Colors.purple : Colors.grey)),
            ],
          ),
        ],
        ),
          ),
        ],
      ),
    );
  }
}
