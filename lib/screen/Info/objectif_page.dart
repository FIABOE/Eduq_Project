import 'package:flutter/material.dart';
import 'package:education/screen/Info/mes_info.dart';

class ObjectifPage extends StatefulWidget {
  const ObjectifPage({Key? key}) : super(key: key);

  @override
  _ObjectifPageState createState() => _ObjectifPageState();
}

class _ObjectifPageState extends State<ObjectifPage> {
  List<ObjectifItem> objectifList = [
    ObjectifItem(
      title: 'Je révise 1h30/semaine',
      description: '',
      icon: Icons.hourglass_full,
      color: Colors.blue,
    ),
    ObjectifItem(
      title: 'Je révise 1h/semaine',
      description: '',
      icon: Icons.hourglass_empty,
      color: Colors.green,
    ),
    ObjectifItem(
      title: 'Je révise 30min/semaine',
      description: '',
      icon: Icons.hourglass_bottom,
      color: Colors.purple,
    ),
    ObjectifItem(
      title: 'Je révise 15min/semaine',
      description: '',
      icon: Icons.hourglass_bottom_outlined,
      color: Colors.orange,
    ),
  ];
  // 
  ObjectifItem? selectedObjectif;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'D-Academy',
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
            size: 30, // Ajuster la taille de l'icone
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Quel est votre objectif ?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF087B95),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: objectifList.length,
              itemBuilder: (context, index) {
                final objectifItem = objectifList[index];
                final isSelected = selectedObjectif == objectifItem;
                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      objectifList.forEach((item) => item.isSelected = false);
                      objectifItem.isSelected = true;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MesinfoPage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isSelected ? objectifItem.color : Colors.white,
                      border: Border.all(
                        color: objectifItem.color,
                        width: 1.5,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: objectifItem.color.withOpacity(0.6),
                            blurRadius: 10,
                            spreadRadius: 3,
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80, 
                           decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            color: isSelected ? Colors.white : objectifItem.color.withOpacity(0.2),
                            // Changez la couleur de fond en fonction de la selection
                          ),
                          child: Icon(
                            objectifItem.icon,
                            size: 40,
                            color: isSelected ? objectifItem.color : Colors.white,
                            // Changez la couleur de l'icône en fonction de selection
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  objectifItem.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: isSelected ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  objectifItem.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected ? Colors.white : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
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

class ObjectifItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  bool isSelected;

  ObjectifItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.isSelected = false, // Assurez-vous de mettre une valeur par défaut ici
  });
}
