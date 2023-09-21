import 'package:education/screen/Compte/Avatar_page.dart';
import 'package:flutter/material.dart';


class UpdateComptePage extends StatefulWidget {
  const UpdateComptePage({Key? key}) : super(key: key);

  @override
  _UpdateComptePageState createState() => _UpdateComptePageState();
}

class _UpdateComptePageState extends State<UpdateComptePage> {
  TextEditingController pseudoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateNaissanceController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController nomController = TextEditingController();

  String dateNaissance = '';
  String prenom = '';
  String nom = '';
  String email = '';
  String pseudo = '';
  String avatarPath = ''; // Remplacez ceci par le vrai chemin de l'avatar choisi

  @override
  void initState() {
    super.initState();
    
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Modifier mes informations',
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
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(avatarPath),
                          radius: 40,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Supprimer le titre du pseudo
                              const SizedBox(height: 4),
                              Text(
                                '$email',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(
                            255, 238, 145, 69), // Couleur du cercle
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AvatarPage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              buildInfoField('Pseudo', pseudoController, (value) {
                setState(() {
                  pseudo = value;
                });
              }),
              buildInfoField('Date de naissance', dateNaissanceController, (value) {
                setState(() {
                  dateNaissance = value;
                });
              }),
              buildInfoField('Prénom', prenomController, (value) {
                setState(() {
                  prenom = value;
                });
              }),
              buildInfoField('Nom', nomController, (value) {
                setState(() {
                  nom = value;
                });
              }),
              buildInfoField('Email', emailController, (value) {
                setState(() {
                  email = value;
                });
              }),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100.0), // Décaler le bouton plus bas
                  child: SizedBox(
                    width: 200, // Réduire la largeur du bouton
                    child: ElevatedButton(
                      onPressed: () {
                        // Action à effectuer lorsque le bouton "Valider" est pressé
                        // Redirection vers une autre page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UpdateComptePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 24.0), // Réduire les côtés du bouton
                        backgroundColor: const Color(
                            0xFF70A19F), // Couleur de l'arrière-plan du bouton
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                               30.0), // Arrondir les bords du bouton
                        ),
                      ),
                      child: const Text(
                        'Valider',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoField(
      String label, TextEditingController controller, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controller, // Utilisez le contrôleur ici
              onChanged: onChanged,
              textAlign: TextAlign.right, // Aligner la valeur à droite
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 235, 83, 23), // Couleur de la valeur
              ),
            ),
          ),
        ],
      ),
    );
  }
}
