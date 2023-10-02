import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AddCours extends StatefulWidget {
  @override
  _AddCoursState createState() => _AddCoursState();
}

class _AddCoursState extends State<AddCours> {
  TextEditingController filiereController = TextEditingController();
  File? selectedFile; // Utilisez File au lieu de PlatformFile
  String? selectedFiliere;

  bool isValiderButtonEnabled = false;

  Future<void> navigateToFiliereSelection() async {
    final selectedFiliere = await Navigator.push<String?>(
      context,
      MaterialPageRoute(
        builder: (context) => ListFiliere(selectedFiliere: this.selectedFiliere),
      ),
    );

    if (selectedFiliere != null) {
      setState(() {
        this.selectedFiliere = selectedFiliere;
        isValiderButtonEnabled = true;
      });
    }
  }

  Future<void> selectPDFFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> submitForm() async {
    try {
      if (selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Veuillez sélectionner un fichier PDF.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (selectedFiliere == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Veuillez sélectionner une filière.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Afficher les valeurs de selectedFiliere et selectedFile
      print('selectedFiliere: $selectedFiliere');
      print('selectedFile: ${selectedFile!.path}');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.137.131:8000/api/cours'),
      );

      request.fields['filiere_libelle'] = selectedFiliere!;

      if (selectedFile != null) {
        final pdfFile = await http.MultipartFile.fromPath(
          'pdf_file',
          selectedFile!.path,
          filename: selectedFile!.path.split('/').last,
        );

        request.files.add(pdfFile);
      }

      final response = await request.send();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cours ajouté avec succès.'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          selectedFile = null;
          selectedFiliere = null;
          isValiderButtonEnabled = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Échec de l\'ajout du cours.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Erreur lors de l\'exécution de la fonction submitForm : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Votre interface utilisateur ici
  }
}

class ListFiliere extends StatelessWidget {
  final String? selectedFiliere;

  ListFiliere({Key? key, this.selectedFiliere}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Interface utilisateur pour la sélection de la filière
  }
}
