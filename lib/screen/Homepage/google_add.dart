Vous avez raison, il est préférable de créer une 
fonction générique de requête HTTP qui peut être réutilisée 
pour éviter la duplication de code. Voici comment vous pouvez c
réer une fonction de requête HTTP réutilisable dans votre code :

dart
Copy code
Future<Map<String, dynamic>> fetchData(String url, Map<String, String> headers) async {
  final response = await http.get(
    Uri.parse(url),
    headers: headers,
  );

  if (response.statusCode == 200 && response.body.isNotEmpty) {
    final Map<String, dynamic> data = json.decode(response.body);
    return data;
  } else {
    throw Exception('Erreur de requête HTTP');
  }
}
Ensuite, vous pouvez utiliser cette fonction pour effectuer vos requêtes HTTP de manière plus propre et réutilisable. Par exemple, voici comment vous pouvez l'utiliser dans votre fonction fetchUserData() :

dart
Copy code
Future<void> fetchUserData() async {
  final prefs = await SharedPreferences.getInstance();
  userToken = prefs.getString('userToken'); 
  print('authentification: $userToken');

  final headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $userToken',
  };

  try {
    final data = await fetchData('http://127.0.0.1:8000/api/user', headers);
    
    final user = data['user'];
    print('utilisateur: $user');
    
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
  } catch (error) {
    print('Erreur lors de la récupération des données de l\'utilisateur : $error');
    // Gérer l'erreur ici, par exemple afficher une boîte de dialogue d'erreur
  }
}
De cette manière, votre code est plus propre, et vous pouvez réutiliser la fonction fetchData() pour d'autres requêtes HTTP dans votre application. N'oubliez pas d'adapter les messages d'erreur et les gestionnaires d'erreurs en fonction de vos besoins spécifiques.


1 / 2




