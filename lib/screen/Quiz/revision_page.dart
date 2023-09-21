// ignore_for_file: library_private_types_in_public_api, unnecessary_const

import 'package:flutter/material.dart';

import '../Compte/compte_page.dart';
import '../Homepage/accueil_page.dart';
import 'add_biblio.dart';
import 'search_page.dart';
import 'temps_page.dart';
import 'statistiques_page.dart';

class RevisionPage extends StatefulWidget {
  const RevisionPage({Key? key}) : super(key: key);

  @override
  _RevisionPageState createState() => _RevisionPageState();
}

class _RevisionPageState extends State<RevisionPage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF70A19F),
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Utiliser le MainAxisAlignment.spaceBetween pour séparer les éléments
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'D-Academy',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            const Text(
              'Révision',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchPage()),
                      );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 24, // Rayon du cercle
              child: Icon(
                Icons.person,
                color: Color.fromARGB(255, 235, 232, 232),
                size: 24, // Taille de l'icône
              ),
            ),
            onPressed: () {
              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ComptePage()),
                      );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TempsPage()),
                          );
                        },
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 82, 201, 181),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                        ),
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Icon(
                                          Icons.watch,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      const Text(
                                        'Min de révision',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    '0 min',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 238, 70, 3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                            //title: Text('Alerte'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'C\'est votre pourcentage de bonnes réponses sur l\'ensemble des quiz proposés pour ton année scolaire. Cartonne dans tous tes quiz pour atteindre le 100%! Pour ton année de ----, tu es à : ---min',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop(); // Ferme la boîte de dialogue
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const RevisionPage()),
                                      );
                                    },
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pour l\'année',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Color.fromARGB(255, 215, 218, 221),
                              child: CircularProgressIndicator(
                                value: 0.5, // Remplacez la valeur avec le pourcentage de progression réel
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(255, 241, 219, 13),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              '0%', // Remplacez la valeur avec le pourcentage de progression réel
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 91, 175, 161),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 4.0),
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: const Color.fromARGB(255, 251, 252, 251), // Couleur de fond de la carte
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0), 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [      
                           CircleAvatar(
                              backgroundImage: AssetImage('assets/images/ve.png',
                              ),
                              radius: 20, // La moitié de la largeur/hauteur souhaitée
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'S\'entrainer sur tous les matières',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromARGB(255, 216, 19, 5),
                              ),
                            ),
                          ],
                        ),
                        // Autres widgets de statistiques par matière
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 4.0),
              child: SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          //title: Text('Alerte'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'C\'est la moyenne des notes obtenues sur les quiz que vous avez déjà terminé pour votre année scolaire.',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Align(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context); // Ferme la boîte de dialogue
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const RevisionPage()),
                                    );
                                  },
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: const Color.fromARGB(255, 111, 179, 190), // Couleur de fond de la carte
                    child: const Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Moyenne générale',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.blue, // Couleur de fond de l'icône
                              child: Icon(
                                Icons.school,
                                color: Colors.white, // Couleur de l'icône
                                size: 40,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Center(
                            child: Text(
                              '9.5', // Moyenne provisoire
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 251, 251, 252),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 4.0),
              child: SizedBox(
                width: double.infinity,
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StaPage()),
                      );
                    },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: const Color.fromARGB(255, 236, 192, 141), // Couleur de fond de la carte
                  child: Padding(
                     padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0), 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/sta.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            const Text(
                              'Mes statistiques par matière',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        // Autres widgets de statistiques par matière
                      ],
                    ),
                  ),
                ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 4.0),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: const Color(0xFFECEFF1), // Couleur de fond de la carte
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mes parcours',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: 3, // Modifier le nombre de cartes ici (3 ou 4)
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Colors.white, // Modifier la couleur de la carte si nécessaire
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      'M${index + 1}', // Texte de la carte (M1, M2, ...)
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 219, 156, 96),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.settings,
                            color: Color.fromARGB(255, 252, 251, 251),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddbiblioPage()),
                            );
                              // Action à effectuer lorsque l'icône de paramètres est pressée
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const SizedBox(height: 16.0),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.3,
                    children: const [
                      ExerciseCard(
                        icon: Icons.watch,
                        color: Colors.blue,
                        title: 'Exercice 1',
                      ),
                      ExerciseCard(
                        icon: Icons.directions_run,
                        color: Colors.green,
                        title: 'Exercice 2',
                      ),
                      ExerciseCard(
                        icon: Icons.fitness_center,
                        color: Colors.orange,
                        title: 'Exercice 3',
                      ),
                      ExerciseCard(
                        icon: Icons.accessibility,
                        color: Colors.red,
                        title: 'Exercice 4',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 460,
              child: Container(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
                  icon: Icon(
                    Icons.home,
                    color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccueilPage()),
                    );
                  },
                ),
                Text(
                  'Accueil',
                  style: TextStyle(
                    color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.library_books,
                    color: _selectedIndex == 1 ? Colors.green : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RevisionPage()),
                    );
                  },
                ),
                Text(
                  'Révision',
                  style: TextStyle(
                    color: _selectedIndex == 1 ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.emoji_events,
                    color: _selectedIndex == 2 ? Colors.orange : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                    // Action pour l'icône de tournoi
                  },
                ),
                Text(
                  'Tournoi',
                  style: TextStyle(
                    color: _selectedIndex == 2 ? Colors.orange : Colors.grey,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.star,
                    color: _selectedIndex == 3 ? Colors.purple : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                    // Action pour l'icône de profil
                  },
                ),
                Text(
                  'Premium',
                  style: TextStyle(
                    color: _selectedIndex == 3 ? Colors.purple : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseCard extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String title;

  const ExerciseCard({
    required this.icon,
    required this.color,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTapped = !_isTapped;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(
          0.0,
          _isTapped ? -10.0 : 0.0,
          0.0,
        ),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _isTapped ? widget.color.withOpacity(0.8) : Colors.grey[100],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isTapped ? Colors.white.withOpacity(0.8) : widget.color,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      widget.icon,
                      color: _isTapped ? widget.color : Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: _isTapped ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}