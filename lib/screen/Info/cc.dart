Pour afficher la filière choisie par l'utilisateur à partir des 
informations stockées dans la base de données, vous devez d'abord 
récupérer ces informations, généralement à partir d'une requête à 
la base de données, puis les utiliser pour mettre à jour le texte 
affiché dans votre interface Flutter. 
Voici comment vous pourriez faire cela :

Assurez-vous d'avoir accès aux données de la filière choisie par l'utilisateur depuis votre base de données. Vous pouvez utiliser un système de gestion de l'état, tel que Provider ou Bloc, pour gérer ces données.

Remplacez le texte statique 'filiere' par la valeur dynamique récupérée depuis la base de données. Pour cela, vous pouvez utiliser un StatefulWidget ou un StatelessWidget avec un gestionnaire d'état.

Voici un exemple simplifié en utilisant un StatelessWidget avec un gestionnaire d'état :

dart
Copy code
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String selectedFiliere = ''; // Initialisez la filière sélectionnée avec une valeur vide

  // Fonction pour récupérer la filière depuis la base de données
  Future<void> fetchFiliereFromDatabase() async {
    // Effectuez une requête à la base de données pour obtenir la filière choisie par l'utilisateur
    // Mettez à jour la valeur de selectedFiliere avec la valeur récupérée depuis la base de données
    selectedFiliere = await fetchFiliere(); // Remplacez fetchFiliere() par votre logique de récupération de données
    setState(() {}); // Mettez à jour l'interface utilisateur pour refléter la nouvelle valeur
  }

  @override
  void initState() {
    super.initState();
    fetchFiliereFromDatabase(); // Appelez la fonction pour récupérer la filière lors de la création du widget
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 4.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: const Color(0xFFECEFF1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mon parcours',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddbiblioPage()),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 219, 156, 96),
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: Color.fromARGB(255, 252, 251, 251),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white, // Modifier la couleur de la sous-carte si nécessaire
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedFiliere, // Utilisez la valeur récupérée depuis la base de données
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
Dans cet exemple, fetchFiliere() représente la fonction que vous devrez implémenter pour récupérer la filière depuis la base de données. Lorsque vous avez la filière, utilisez setState pour mettre à jour l'interface utilisateur avec la valeur récupérée. Cela garantit que la filière sélectionnée par l'utilisateur est correctement affichée.




