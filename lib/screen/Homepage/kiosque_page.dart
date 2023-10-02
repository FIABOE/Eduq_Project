
                              style: TextStyle(
                                color: Color.fromARGB(255, 253, 253, 253), 
                                fontSize: 16, 
                                fontWeight: FontWeight.bold, // Mettre le texte en gras si nécessaire
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 252, 202, 145), // Changer la couleur du bouton en vert
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5), // Arrondir les bords du bouton avec un rayon de 5
                              ),
                            ),
                          ),
                            const Text(
                              'En savoir plus',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 254), // Changer la couleur du texte en bleu
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[100], // Couleur de fond du cadre
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Objectifs hebdomadaires',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  child: IconButton(
                                    icon: Icon(
                                      isListVisible ? Icons.close : Icons.edit,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isListVisible = !isListVisible;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              height: isListVisible ? 200 : 0, // Hauteur de la liste
                              child: isListVisible
                              ? ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text('Élément $index'),
                                    onTap: () {
                                      // Gérez la sélection de l'élément ici
                                      print('Élément $index sélectionné');
                                    },
                                  );
                                },
                              )
                            : null,
                            ),
                          ]
                          SizedBox(height: 10),
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
                          SizedBox(height: 10),
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
                                userData['Objectif hebdomadaire'] != null
                                ? '${_extractDuration(userData['Objectif hebdomadaire'])} min'
                                : 'Objectif hebdomadaire non disponible',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 248, 232, 5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),