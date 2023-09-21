import 'package:flutter/material.dart';
import 'package:education/screenAdmin/Add_filiere.dart';
import 'package:education/screenAdmin/AddCours_page.dart';
import 'package:education/screenAdmin/AddObjectif_page.dart';
import 'package:education/screenAdmin/AddQuiz_page.dart';
import 'package:education/screenAdmin/listeADD/ListCours.dart';
import 'package:education/screenAdmin/listeADD/ListeFill.dart';
import 'package:education/screenAdmin/listeADD/ListObjectif.dart';
import 'package:education/screenAdmin/listeADD/ListQuiz.dart';
import 'package:education/screen/omboard/onboarding_screen.dart';
import 'package:education/screenAdmin/AddQuiz_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:http/http.dart' as http;

class AccueilMod extends StatefulWidget {
  const AccueilMod({Key? key}) : super(key: key);

  @override
  _AccueilModState createState() => _AccueilModState();
}

class _AccueilModState extends State<AccueilMod> {
  String userName=''; 

  // Fonction pour charger le nom de l'utilisateur depuis les préférences partagées
  void _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? ''; 
      //prefs.setString('userName', user.name);
    });
  }
  
  @override
   void initState() {
    super.initState();
    _loadUserName(); 
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: RoundedBottomAppBar(
          userName: userName,
        ),
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
  final String userName; 

  RoundedBottomAppBar({Key? key, required this.userName}); 

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
            userName.isNotEmpty ? userName : '',//Name du modérateur
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
