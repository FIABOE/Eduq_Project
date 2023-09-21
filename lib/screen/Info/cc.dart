Le message "Token d'authentification :" suivi d'une chaîne vide indique que le token d'authentification 
n'est pas correctement récupéré depuis les préférences de l'application. Pour résoudre ce problème, 
vous devez vous assurer que le token est correctement stocké dans les préférences de l'application lorsque 
l'utilisateur se connecte ou s'inscrit.

Voici quelques étapes à suivre pour résoudre ce problème :

Assurez-vous que le token d'authentification est correctement stocké dans les préférences 
de l'application après l'authentification de l'utilisateur. Cela devrait se faire dans 
la partie de votre code qui gère l'authentification. Voici un exemple de code pour
stocker le token :
dart
Copy code
// Après avoir obtenu le token lors de l'authentification
final prefs = await SharedPreferences.getInstance();
prefs.setString('userToken', userToken); // Stockez le token avec la clé appropriée
Assurez-vous que le code pour récupérer le token depuis les préférences est correctement placé dans la fonction _getUserToken() de votre code. Vous avez déjà le bon code pour cela :
dart
Copy code
// Fonction pour obtenir le token d'authentification depuis les préférences de l'application
Future<void> _getUserToken() async {
  final prefs = await SharedPreferences.getInstance();
  userToken = prefs.getString('userToken') ?? ''; // Assurez-vous de gérer le cas où le token n'est pas trouvé
  print('Token d\'authentification : $userToken'); // Vérifiez la valeur du token
}
Assurez-vous d'appeler la fonction _getUserToken() 
dans la méthode initState() de votre widget pour obtenir 
le token lors de l'initialisation de la page. Vous l'avez déjà fait correctement dans votre code.

Vérifiez que le token est correctement stocké avec la clé 'userToken' 
dans les préférences de l'application. Vous pouvez le vérifier en 
accédant aux préférences de votre application 
'(par exemple, en utilisant l\'extension "Flutter DevTools" dans votre navigateur).

Assurez-vous que l'utilisateur est correctement authentifié avant d'essayer d'accéder à la page FilierePage. Vous pouvez utiliser des gardiens d'authentification pour cela, comme mentionné précédemment.

Après avoir suivi ces étapes, assurez-vous que le token d'authentification est correctement stocké et récupéré depuis les préférences de l'application. Cela devrait résoudre le problème du message "L'utilisateur n'est pas authentifié" lorsque vous effectuez la requête HTTP. Si le problème persiste, assurez-vous que l'authentification de l'utilisateur est correcte et que le token est bien obtenu lors de la connexion ou de l'inscription.




