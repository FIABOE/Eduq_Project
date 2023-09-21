import 'package:flutter/material.dart';
import 'add_biblio.dart';

class StatistiquePage extends StatefulWidget {
  const StatistiquePage({Key? key}) : super(key: key);

  @override
  _StatistiquePageState createState() => _StatistiquePageState();
}

class _StatistiquePageState extends State<StatistiquePage> {
  String cursus = ''; 
  String filiere = ''; 
  List<String> subjects= [];

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
            'Mes statistiques par Matière',
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Liste des parcours',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 161, 62, 23),
                  ),
                ),

                Container(
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
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(subjects[index]),
                    onTap: () {
                      // Action lors du clic sur une matière
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 80),
            const Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/sti.jpg'),
                  radius: 50, // La moitié de la largeur/hauteur souhaitée
                ),
                SizedBox(height: 25),
                Text(
                  'Aucun Résultat de Quiz',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFF087B95),
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Vous n\'avez répondu à aucune question pour le moment. Commencer à réviser',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Spacer(),
            Center(
              child: SizedBox(
                width: 180.0, // Définir la largeur souhaitée ici
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StatistiquePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: const Color(0xFF70A19F),
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Allez aux Quiz',
                        style: TextStyle(
                          color:Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
