import 'package:flutter/material.dart';
import 'package:education/screenAdmin/Add_filiere.dart';
import 'package:education/screenAdmin/AddCours_page.dart';
import 'package:education/screenAdmin/AddObjectif_page.dart';
import 'package:education/screenAdmin/AddQuiz_page.dart';
import 'package:education/screenAdmin/listeADD/ListCours.dart';
import 'package:education/screenAdmin/listeADD/ListeFill.dart';
import 'package:education/screenAdmin/listeADD/ListObjectif.dart';
import 'package:education/screenAdmin/listeADD/ListQuiz.dart';
import 'package:education/screenAdmin/listeADD/ListMod.dart';
import 'package:education/screen/omboard/onboarding_screen.dart';
import 'package:education/screenAdmin/AddQuiz_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AdAccueilPage extends StatefulWidget {
  const AdAccueilPage({Key? key}) : super(key: key);

  @override
  _AdAccueilPageState createState() => _AdAccueilPageState();
}

class _AdAccueilPageState extends State<AdAccueilPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController motDePasseController = TextEditingController();

  bool isValiderActive = false;
  String? selectedRole; // Variable pour stocker le rôle sélectionné


  void _afficherBoiteDialogue(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        selectedRole = null;
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.add, // Icône que vous pouvez personnaliser
                color: Colors.green, // Couleur de l'icône
              ),
              SizedBox(width: 10), // Espacement entre l'icône et le texte
              Text(
                'Ajouter un modérateur',
                style: TextStyle(
                  fontSize: 18, // Taille du texte
                  fontWeight: FontWeight.bold, // Poids de la police
                  color: Colors.blue, // Couleur du texte
                ),
              ),
            ],
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nomController,
                  decoration: InputDecoration(labelText: 'Nom'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Veuillez entrer votre nom.';
                    }
                    if (value?.length == 1) {
                      return 'Le nom doit comporter plus d\'une lettre.';
                    }
                    if (RegExp(
                            r'[0-9!@#%^&*()_+={}\[\]:;<>,.?~\\/]')
                        .hasMatch(value ?? '')) {
                      return 'Le nom ne doit pas contenir de chiffres ou de caractères spéciaux.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: prenomController,
                  decoration: InputDecoration(labelText: 'Prénom'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Veuillez entrer votre prénom.';
                    }
                    if (value?.length == 1) {
                      return 'Le prénom doit comporter plus d\'une lettre.';
                    }
                    if (RegExp(
                            r'[0-9!@#%^&*()_+={}\[\]:;<>,.?~\\/]')
                        .hasMatch(value ?? '')) {
                      return 'Le prénom ne doit pas contenir de chiffres ou de caractères spéciaux.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Veuillez entrer votre email.';
                    }
                    if (!isValidEmail(value ?? '')) {
                      return 'Veuillez entrer une adresse email valide.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: motDePasseController,
                  decoration: InputDecoration(labelText: 'Mot de passe'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Veuillez entrer votre mot de passe.';
                    }
                    if (value!.length < 8) {
                      return 'Le mot de passe doit comporter au moins 8 caractères.';
                    }
                    // Ajoutez ici d'autres conditions de validation si nécessaire
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                   // Champ de liste déroulante du rôle (ajouté)
                  value: selectedRole,
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value as String?;
                    });
                  },
                  items: ['Modérateur', 'Administrateur'].map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Rôle'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner un rôle.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // Couleur du bouton "Annuler" (rouge)
                        onPrimary: Colors.white, // Couleur du texte (blanc)
                      ),
                      child: Text('Annuler'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          registerModerateur(); // Appel de la fonction pour envoyer la requête HTTP
                          Navigator.of(context).pop(); // Fermer la boîte de dialogue
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF70A19F), // Couleur du bouton "Valider" (personnalisée)
                        onPrimary: Colors.white, // Couleur du texte (blanc)
                      ),
                      child: Text('Valider'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
  bool isValidEmail(String email) {
    final RegExp regex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+)$');
    return regex.hasMatch(email);
  }
  
  Future<void> registerModerateur() async {
  final String apiUrl = 'http://127.0.0.1:8000/api/register-moderateur'; 

  final Map<String, dynamic> formData = {
    'surname': nomController.text,
    'name': prenomController.text,
    'email': emailController.text,
    'password': motDePasseController.text,
    'role': selectedRole, // Ajoutez le rôle aux données envoyées à l'API
  };
  
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: formData,
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Modérateur enregistré avec succès'),
          backgroundColor: const Color(0xFF70A19F),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ce modérateur existe déjà'),
          backgroundColor: const Color(0xFF70A19F),
        ),
      );
    }
  } catch (error) {
    // Gestion des erreurs réseau ou autres
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: RoundedBottomAppBar(),
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundedTopRightCard(
              child: Container(
                padding: EdgeInsets.all(32),
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF70A19F),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
                child: Text(
                  'Graphique ici',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _afficherBoiteDialogue(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF70A19F),
                  onPrimary: Colors.white,
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('Ajouter un modérateur'), // Texte personnalisé
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return RoundedTopRightCard(
                    child: buildCustomCard(index),
                    onPressed: () {
                      switch (index) {
                        case 0:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddFiliere(),
                            ),
                          );
                          break;
                        case 1:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddObjectif(),
                            ),
                          );
                          break;
                        case 2:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCours(),
                            ),
                          );
                          break;
                        case 3:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddQuiz(),
                            ),
                          );
                          break;
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getCurrentDate() {
    final now = DateTime.now();
    final formattedDate = "${now.day}/${now.month}/${now.year}";
    return formattedDate;
  }

  Widget buildCustomCard(int index) {
    String cardTitle = '';
    IconData cardIcon = Icons.star;
    Color cardColor = Colors.white;

    switch (index) {
      case 0:
        cardTitle = 'Filiere';
        cardIcon = Icons.school;
        cardColor = const Color(0xFFE57373);
        break;
      case 1:
        cardTitle = 'Objectif';
        cardIcon = Icons.assignment;
        cardColor = const Color(0xFF81C784);
        break;
      case 2:
        cardTitle = 'Cours';
        cardIcon = Icons.book;
        cardColor = const Color(0xFF64B5F6);
        break;
      case 3:
        cardTitle = 'Quiz';
        cardIcon = Icons.quiz;
        cardColor = Colors.orange;
        break;
    }

    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    cardIcon,
                    size: 50,
                    color: cardColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    cardTitle,
                    style: TextStyle(fontSize: 20, color: cardColor),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                // Utilisez un sélecteur d'index pour déterminer l'action du bouton
                switch (index) {
                  case 0:
                    // Exécutez l'action pour la carte "Filiere"
                    break;
                  case 1:
                    // Exécutez l'action pour la deuxième carte
                    break;
                  case 2:
                    // Exécutez l'action pour la troisième carte
                    break;
                  case 3:
                    // Exécutez l'action pour la quatrième carte
                    break;
                }
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(16),
                primary: cardColor,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white, 
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: const Color(0xFF70A19F),
        elevation: 5,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Admin',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    getCurrentDate(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getCurrentDate() {
    final now = DateTime.now();
    final formattedDate = "${now.day}/${now.month}/${now.year}";
    return formattedDate;
  }
}

class RoundedTopRightCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  RoundedTopRightCard({required this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(0.0),
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
      ),
      child: InkWell(
        onTap: onPressed, 
        child: child,
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextStyle drawerItemStyle = TextStyle(
      color: Colors.black, // Couleur du texte en noir
      fontSize: 18, // Taille du texte
      fontWeight: FontWeight.bold, // Texte en gras
    );

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color(0xFF70A19F),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 40,
                ),
                Text(
                  'D-Academy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.list,
              color: const Color(0xFF70A19F), // Couleur de l'icône
            ),
            title: Text(
              'Liste de filières',
              style: drawerItemStyle, // Utilisation du style personnalisé
            ),
             onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/ListFill'); // Redirige vers ListFill
            },
          ),
          ListTile(
            leading: Icon(
              Icons.check_circle,
              color: const Color(0xFF70A19F), // Couleur de l'icône
            ),
            title: Text(
              'Liste d\'objectifs',
              style: drawerItemStyle, // Utilisation du style personnalisé
            ),
             onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/ListObjectif'); // Redirige vers ListFill
            },
          ),
          ListTile(
            leading: Icon(
              Icons.library_books,
              color: const Color(0xFF70A19F), // Couleur de l'icône
            ),
            title: Text(
              'Liste de cours',
              style: drawerItemStyle, // Utilisation du style personnalisé
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/ListCours'); // Redirige vers ListFill
            },
          ),
          ListTile(
            leading: Icon(
              Icons.quiz,
              color: const Color(0xFF70A19F), // Couleur de l'icône
            ),
            title: Text(
              'Liste de quiz',
              style: drawerItemStyle, // Utilisation du style personnalisé
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/ListQuiz'); // Redirige vers ListFill
            },
          ),
          ListTile(
            leading: Icon(
              Icons.people,
              color: const Color(0xFF70A19F), 
            ),
            title: Text(
              'Liste des modérateur',
              style: drawerItemStyle, 
            ),
             onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/ListMod'); 
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: const Color(0xFF70A19F), // Couleur de l'icône
            ),
            title: Text(
              'Déconnexion',
              style: drawerItemStyle, // Utilisation du style personnalisé
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/OnboardingScreen'); // Redirige vers ListFill
            },
          ),
        ],
      ),
    );
  }
}
