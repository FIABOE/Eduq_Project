import 'package:flutter/material.dart';
import 'package:education/screenAdmin/AddCours_page.dart';

class ListCours extends StatefulWidget {
  const ListCours({Key? key}) : super(key: key);

  @override
  _ListCoursState createState() => _ListCoursState();
}

class _ListCoursState extends State<ListCours> {
  List<String> cours = [
    'Cours 1',
    'Cours 2',
    'Cours 3',
    // Ajoutez d'autres cours ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Liste des cours',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
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
  color: Colors.blueGrey, // Couleur du rectangle d'ajout
  padding: EdgeInsets.symmetric(vertical: 16),
  child: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddCours(), // Redirige vers AddQuiz
        ),
      );
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add,
          color: Colors.white, // Couleur de l'icône d'ajout
        ),
        SizedBox(width: 8),
        Text(
          'Ajouter',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Couleur du texte d'ajout
          ),
        ),
      ],
    ),
  ),
),

          SizedBox(height: 16), // Espace entre le rectangle d'ajout et la liste
          Expanded(
            child: ListView.builder(
              itemCount: cours.length,
              itemBuilder: (context, index) {
                final cour = cours[index]; // Renommez la variable ici
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(
                      cour, // Utilisez la variable renommée ici
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
                Icons.remove_red_eye, // Icône "vue"
                color: Colors.green, // Couleur de l'icône "vue"
              ),
              onPressed: () {
                // Action lorsque l'icône "vue" est cliquée
                // Vous pouvez définir l'action ici pour voir le quiz
              },
            ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.orange, // Couleur de l'icône d'édition
                          ),
                          onPressed: () {
                            // Action lorsque l'icône de modification est cliquée
                            // Vous pouvez ouvrir la page de modification de filière ici
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red, // Couleur de l'icône de suppression
                          ),
                          onPressed: () {
                            // Action lorsque l'icône de suppression est cliquée
                            // Vous pouvez supprimer la filière de la liste ici
                            setState(() {
                              cours.removeAt(index);
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
