// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TempsPage extends StatefulWidget {
  const TempsPage({Key? key}) : super(key: key);

  @override
  _TempsPageState createState() => _TempsPageState();
}

class _TempsPageState extends State<TempsPage> {
  // Exemple de données de progression
  final List<ProgressData> data = [
    ProgressData(DateTime(2023, 7, 1), 0), // Point de départ (date de la première semaine)
    ProgressData(DateTime(2023, 7, 8), 10), // Exemple : 10% de progression (date de la deuxième semaine)
    ProgressData(DateTime(2023, 7, 15), 30), // Exemple : 30% de progression
    ProgressData(DateTime(2023, 7, 22), 60), // Exemple : 60% de progression
    ProgressData(DateTime(2023, 7, 29), 100), // Objectif atteint (date de la quatrième semaine)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Temps de révision',
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
            size: 30, // Ajuster la taille de l'icône
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Statistiques',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Nombres de minutes passées dans l\'app',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8.0),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 300,
                    child: charts.TimeSeriesChart(
                      _createSeriesData(),
                      animate: true,
                      domainAxis: const charts.DateTimeAxisSpec(
                        tickProviderSpec: charts.DayTickProviderSpec(increments: [7]), // Une étiquette toutes les 7 jours
                      ),
                      primaryMeasureAxis: charts.NumericAxisSpec(
                        tickProviderSpec: const charts.StaticNumericTickProviderSpec(
                          // Définir les valeurs de l'axe Y (verticale)
                          <charts.TickSpec<num>>[
                            charts.TickSpec<num>(0),
                            charts.TickSpec<num>(25),
                            charts.TickSpec<num>(50),
                            charts.TickSpec<num>(75),
                            charts.TickSpec<num>(100),
                          ],
                        ),
                        renderSpec: charts.GridlineRendererSpec(
                          // Personnaliser les lignes de la grille
                          lineStyle: charts.LineStyleSpec(
                            dashPattern: const [4, 4],
                            color: charts.MaterialPalette.gray.shade400,
                          ),
                        ),
                      ),
                      defaultRenderer: charts.LineRendererConfig(
                        includeArea: true, // Afficher une bande sous la courbe
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Temps de révision',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16.0),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.book),
                      title: Text('Mathématiques'),
                      trailing: Text('12 minutes'),
                    ),
                  ),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.book),
                      title: Text('Français'),
                      trailing: Text('9 minutes'),
                    ),
                  ),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.book),
                      title: Text('Histoire'),
                      trailing: Text('6 minutes'),
                    ),
                  ),
                  // Ajoutez d'autres cartes de matières ici...
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<charts.Series<ProgressData, DateTime>> _createSeriesData() {
    return [
      charts.Series<ProgressData, DateTime>(
        id: 'Progression',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ProgressData data, _) => data.date,
        measureFn: (ProgressData data, _) => data.y,
        data: data,
      ),
    ];
  }
}

class ProgressData {
  final DateTime date; // Date de la semaine
  final int y; // Valeur de l'axe Y

  ProgressData(this.date, this.y);
}
