import 'package:education/screen/Info/list_filière.dart';
import 'package:education/screenAdmin/listeADD/ListCours.dart';
import 'package:education/screen/Info/list_filière.dart';
import 'package:education/screenAdmin/listeADD/ListCours.dart';
import 'package:education/screen/Info/list_filière.dart';
import 'package:education/screenAdmin/listeADD/ListCours.dart';
import 'package:education/screen/Info/list_filière.dart';
import 'package:education/screenAdmin/listeADD/ListCours.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class AddCours extends StatefulWidget {
  const AddCours({Key? key}) : super(key: key);

  @override
  _AddCoursState createState() => _AddCoursState();
}

class _AddCoursState extends State<AddCours> {
  TextEditingController filiereController = TextEditingController();
  PlatformFile? selectedFile; // Utilisez PlatformFile au lieu de File
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
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }

  Future<void> submitForm() async {
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

  final request = http.MultipartRequest(
    'POST',
    Uri.parse('http://127.0.0.1:8000/api/cours'),
  );

  request.fields['filiere_libelle'] = selectedFiliere!;

    final pdfFile = http.MultipartFile(
      'pdf_file',
      selectedFile!.readStream!,
      selectedFile!.size,
      filename: selectedFile!.name,
    );

    request.files.add(pdfFile);

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
  }
  @override 
  void dispose() {
    filiereController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajouter un cours',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF70A19F),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListCours(),
                ),
              );
            },
            child: Row(
              children: [
                Icon(
                  Icons.list,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: selectPDFFile,
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF70A19F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.file_upload,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Sélectionner un fichier',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: navigateToFiliereSelection,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color.fromARGB(255, 204, 203, 203),
                    width: 2.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filière',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 17, 15, 15),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          selectedFiliere ?? 'Sélection',
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedFiliere != null ? const Color(0xFF087B95) : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: isValiderButtonEnabled ? submitForm : null,
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF70A19F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Soumettre',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF0F0F0),
    );
  }
}
