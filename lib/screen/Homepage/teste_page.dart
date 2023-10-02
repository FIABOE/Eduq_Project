Pour extraire le temps de l'objectif enregistré de la manière 
suivante "Je revise 30min/semaine" et afficher uniquement "30 min" dans votre code Flutter, vous pouvez utiliser une méthode de traitement de chaîne pour extraire le temps de la chaîne. Voici comment vous pourriez le faire :

dart
Copy code
// Méthode pour extraire le temps de l'objectif
String extractTimeFromObjective(String objective) {
  // Divisez la chaîne en utilisant l'espace comme séparateur
  List<String> parts = objective.split(' ');

  // Parcourez les parties de la chaîne pour trouver le temps
  for (int i = 0; i < parts.length; i++) {
    // Si la partie contient "min", vous avez trouvé le temps
    if (parts[i].contains('min')) {
      // Retournez cette partie et la suivante pour inclure l'unité de temps
      return parts[i - 1] + ' ' + parts[i];
    }
  }

  // Si aucune correspondance n'est trouvée, retournez une chaîne vide
  return '';
}

// Utilisation de la méthode pour extraire le temps de l'objectif
String objective = userData['Objectif hebdomadaire'] ?? '';
String time = extractTimeFromObjective(objective);

// Affichage du temps dans votre widget
Text(
  time,
  style: TextStyle(
    color: Color.fromARGB(255, 248, 232, 5),
    fontWeight: FontWeight.bold,
  ),
),
Assurez-vous d'appeler cette méthode à l'endroit approprié dans votre 
code pour extraire le temps de l'objectif enregistré et l'afficher correctement



Il semble y avoir une confusion dans votre code. 
L'erreur "Not a constant expression" se produit 
parce que vous essayez d'appeler la méthode buildFiliereWidget() 
à un endroit où une expression constante est attendue. Cela ne fonctionnera 
pas car buildFiliereWidget() est une méthode qui renvoie un widget, et les expressions 
constantes doivent être résolues lors de la compilation.

Pour afficher l'objectif hebdomadaire, vous devez appeler buildFiliereWidget() dans le corps de votre widget build. Voici comment vous pourriez organiser votre code pour résoudre ce problème :

dart
Copy code
class VotreClasse extends StatelessWidget {
  // ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ...
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Autres widgets ici...

            const SizedBox(height: 5),
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
                                // Gérer l'appui sur le bouton d'édition ici...
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
                          buildFiliereWidget(), // Appel à la méthode ici
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Autres widgets ici...
          ],
        ),
      ),
    );
  }

  // ...
}
Assurez-vous d'appeler buildFiliereWidget() à l'endroit approprié dans la structure de votre widget build, comme indiqué ci-dessus.


2 / 2






Je m'excuse pour la confusion. Voici comment vous pouvez organiser votre code complet en utilisant FutureBuilder pour afficher l'objectif hebdomadaire extrait de la base de données :

dart
Copy code
import 'package:flutter/material.dart';

class VotreClasse extends StatelessWidget {
  // ...

  Future<String> fetchObjective() async {
    // Replacez cette méthode par votre logique pour obtenir l'objectif depuis la base de données.
    // Par exemple, vous pouvez utiliser SharedPreferences pour obtenir l'objectif stocké.
    final prefs = await SharedPreferences.getInstance();
    final objective = prefs.getString('userObjective');
    return objective ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ...
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Autres widgets ici...

            const SizedBox(height: 5),
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
                                // Gérer l'appui sur le bouton d'édition ici...
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
                          FutureBuilder<String>(
                            future: fetchObjective(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator(); // Affiche un indicateur de chargement en attendant.
                              } else if (snapshot.hasError) {
                                return Text('Erreur : ${snapshot.error}');
                              } else {
                                final String objective = snapshot.data ?? '';
                                final String time = extractTimeFromObjective(objective);

                                return Text(
                                  time,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 248, 232, 5),
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Autres widgets ici...
          ],
        ),
      ),
    );
  }
}
Assurez-vous de remplacer fetchObjective() par votre propre méthode qui obtient l'objectif depuis votre base de données ou une autre source de données. Le code ci-dessus utilise FutureBuilder pour attendre que l'objectif soit récupéré avant de l'afficher dans votre widget.




Il semble que vous ayez des erreurs dans votre code 
car vous tentez d'accéder à des valeurs (userData) 
avant qu'elles ne soient initialisées. Dans Flutter, 
vous ne pouvez pas accéder à this dans les initialisateurs de champs.
Pour résoudre ces erreurs, vous devriez déplacer ces initialisations dans 
la méthode initState qui est appelée lorsque l'état de votre widget est initialisé. 
Voici comment vous pouvez faire cela :

dart
Copy code
class _AccueilPageState extends State<AccueilPage> {
  int _selectedIndex = 0;
  double progression = 0.2; // Exemple de progression (0.0 à 1.0)

  // ... Autres déclarations de variables ...

  String objective = ''; // Déplacez ces initialisations ici
  String time = '';

  // ... Autres méthodes ...

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    // ... Votre code de récupération de données ...

    if (user.containsKey('Objectif hebdomadaire')) {
      setState(() {
        userData = {
          'Objectif hebdomadaire': user['Objectif hebdomadaire'],
        };
        objective = userData['Objectif hebdomadaire'] ?? ''; // Initialisation ici
        time = extractTimeFromObjective(objective); // Initialisation ici
        print('Filiere récupérée avec succès : ${userData['Objectif hebdomadaire']}');
      });
    } else {
      print("La clé 'Filiere' n'est pas présente dans les données de l'utilisateur.");
    }
  }

  // ... Le reste de votre code ...
}
Avec ces modifications, vous évitez d'accéder à userData avant qu'il ne soit initialisé, ce qui devrait résoudre les erreurs que vous avez rencontrées. Assurez-vous de faire ces modifications pour toutes les valeurs que vous initialisiez dans les initialisateurs de champs.







Future<String> fetchObjective() async {
  final prefs = await SharedPreferences.getInstance();
  final userToken = prefs.getString('userToken');
  
  final response = await http.get(
    Uri.parse('URL_de_votre_api_pour_récupérer_l_objectif'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    },
  );
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    
    if (data.containsKey('objectif')) {
      final String objective = data['objectif'];
      return objective;
    } else {
      return ''; // Retournez une chaîne vide si l'objectif n'est pas trouvé
    }
  } else {
    throw Exception('Erreur lors de la récupération de l\'objectif');
  }
}



children: [
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
          buildFiliereWidget(), // Utilisez buildFiliereWidget() ici
        ],
      ),
    ],







    L'erreur que vous obtenez indique que vous essayez 
    d'appeler buildFiliereWidget() à un endroit où Flutter 
    attendrait une expression constante. Dans Flutter, les 
    widgets doivent être créés de manière déclarative et statique, 
    ce qui signifie que vous ne pouvez pas appeler directement une fonction 
    qui renvoie un widget à cet endroit. Vous devez plutôt utiliser un widget 
    existant qui peut contenir le contenu que vous souhaitez afficher dynamiquement.

Pour résoudre cette erreur, vous pouvez utiliser un widget FutureBuilder pour afficher dynamiquement le contenu en fonction du résultat de votre fetchUserData(). Voici comment vous pouvez le faire :

dart
Copy code
Container(
  // ...
  child: Column(
    children: [
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
          FutureBuilder<void>(
            future: fetchUserData(), // Appelez fetchUserData() ici
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Affichez un indicateur de chargement en attendant les données
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Gérez les erreurs ici
                return Text('Erreur : ${snapshot.error}');
              } else {
                // Affichez les données lorsque fetchUserData() est terminée
                return buildFiliereWidget();
              }
            },
          ),
        ],
      ),
    ],
  ),
),
Assurez-vous que fetchUserData() renvoie Future<void> et que vous appelez la fonction directement dans FutureBuilder. Le widget FutureBuilder se charge d'appeler la fonction et de gérer l'affichage en fonction de l'état de la future.

Avec cette modification, l'appel à fetchUserData() est déclenché de manière asynchrone, 
et le contenu sera affiché correctement une fois


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
                                  time,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 248, 232, 5),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),








                            class _AccueilPageState extends State<AccueilPage> {
  int _selectedIndex = 0;
  double progression = 0.2;
  List<IconData> badgeIcons = [Icons.bookmark, Icons.star, Icons.label];
  String pseudo = '';
  String avatarUrl = '';
  String? userToken;
  String objective = '';
  String time = '';
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('userToken');

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

      if (user.containsKey('Objectif hebdomadaire')) {
        setState(() {
          userData = {
            'Objectif hebdomadaire': user['Objectif hebdomadaire'],
          };
          objective = userData['Objectif hebdomadaire'] ?? '';
          time = extractTimeFromObjective(objective);
        });
      } else {
        print("La clé 'Filiere' n'est pas présente dans les données de l'utilisateur.");
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

  // Reste de votre code...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ...
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
                    // ...
                  ),
                  const SizedBox(height: 5),
                  Card(
                    // ...
                    child: Container(
                      // ...
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
                                  // ...
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
                                    // ...
                                  ),
                                ),
                              ],
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
                                  time,
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
                  // Le reste de votre code...
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
