// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Profil/profil_page.dart';
import 'Avatar_page.dart';
import 'update_page.dart';
import '../omboard/onboarding_screen.dart';

class ComptePage extends StatefulWidget {
  const ComptePage({Key? key}) : super(key: key);

  @override
  _ComptePageState createState() => _ComptePageState();
}

class _ComptePageState extends State<ComptePage> {

  String pseudo = '';
  String email = '';
  String avatarPath = ''; // Remplacez ceci par le vrai chemin de l'avatar choisi
 
  @override
  void initState() {
    super.initState();
  }
  
    
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text(
            'Déconnexion',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
         ),
          content: const Text(
            'Êtes-vous sûr de vouloir vous déconnecter ?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Annuler',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ComptePage()),
                        );
              },
            ),
            TextButton(
              child: const Text(
                'Se déconnecter',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                        );
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Suppression de compte',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            ),
          content: const Text(
            'Voulez-vous vraiment supprimer votre compte ? Vous perdrez toute votre progression dans l\'application.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Annuler',
                style: TextStyle(
               fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
              ),
              onPressed: () {
                Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ComptePage()),
                        );
              },
            ),
            TextButton(
              child: const Text(
                'Supprimer ',
                style: TextStyle(
               fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
              ),
              onPressed: () {
                // Ajoutez ici la logique pour la suppression du compte
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Mon compte',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      centerTitle: true,
      backgroundColor: Color(0xFF70A19F),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white, // Couleur de l'arrière-plan du profil
              borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AvatarPage()),
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage: AssetImage(avatarPath),
                      radius: 40,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' $pseudo',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          ' $email',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
              const SizedBox(height: 32),
              MenuItem(
                icon: Icons.edit,
                title: 'Modifier mon compte',
                color: Colors.deepOrange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UpdateComptePage()),
                  );
                },
              ),
              const MenuItem(
                icon: Icons.favorite,
                title: 'Mes cours favoris',
                color: Colors.red,
              ),
              //MenuItem(
                //icon: Icons.person,
                //title: 'Mon profil',
                //circleIcon: true,
                //color: Colors.blue,
                //onTap: () {
                  //Navigator.push(
                   // context,
                    //MaterialPageRoute(builder: (context) => const ProfilPage()),
                  //);
                //},
              //),
              const MenuItem(
                icon: Icons.settings,
                title: 'Paramètres',
                color: Colors.green,
              ),
              const MenuItem(
                icon: Icons.star,
                title: 'Noter l\'application',
                color: Colors.amber,
              ),
              const MenuItem(
                icon: Icons.share,
                title: 'Partager l\'application',
                color: Colors.indigo,
              ),
              const MenuItem(
                icon: Icons.support,
                title: 'Support',
                color: Colors.teal,
              ),
              const MenuItem(
                icon: Icons.business,
                title: 'Nos offres pour les pro',
                color: Colors.purple,
              ),
              MenuItem(
                icon: Icons.logout,
                title: 'Se déconnecter',
                circleIcon: true,
                color: Colors.orange,
                onTap: () {
                  _showLogoutConfirmationDialog();
                },
              ),
              MenuItem(
                icon: Icons.delete,
                title: 'Supprimer mon compte',
                circleIcon: true,
                color: Colors.red,
                deleteIcon: true,
                onTap: () {
                  _showDeleteAccountConfirmationDialog();
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final bool circleIcon;
  final bool deleteIcon;
  final VoidCallback? onTap;

  const MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    this.color = Colors.black,
    this.circleIcon = false,
    this.deleteIcon = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Ajout de l'ontap ici
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: circleIcon ? BoxShape.circle : BoxShape.rectangle,
            color: deleteIcon ? Colors.red : color,
            border: deleteIcon ? Border.all(color: Colors.red, width: 2.0) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 3.0,
                spreadRadius: 1.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: deleteIcon ? const Icon(Icons.close, color: Colors.white, size: 20) : Icon(icon, color: Colors.white, size: 24),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }
}
