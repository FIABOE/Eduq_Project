import 'package:flutter/material.dart';
import 'screen/Homepage/accueil_page.dart';
import 'screen/omboard/onboarding_screen.dart';
import 'screen/splash/splash_screen.dart';
import 'screen/authentification/login_page.dart';
import 'screen/authentification/register_page.dart';
import 'screen/authentification/editPass.dart';
import 'screen/Info/filière_Page.dart';
import 'screen/Info/objectif_page.dart';
import 'screen/Info/list_filière.dart';
import 'screenAdmin/AdAccueil_Page.dart';
import 'package:education/screenAdmin/accueilModérateur.dart';
import 'package:education/models/user.dart';
import 'package:education/screenAdmin/Add_filiere.dart';
import 'package:education/screenAdmin/AddCours_page.dart';
import 'package:education/screenAdmin/AddObjectif_page.dart';
import 'package:education/screenAdmin/AddQuiz_page.dart';
import 'package:education/screenAdmin/listeADD/ListeFill.dart';
import 'package:education/screenAdmin/listeADD/ListObjectif.dart';
import 'package:education/screenAdmin/listeADD/ListQuiz.dart';
import 'package:education/screenAdmin/listeADD/ListMod.dart';
import 'package:education/screen/omboard/onboarding_screen.dart';
import 'package:education/screenAdmin/listeADD/ListCours.dart';
import 'package:education/screen/Homepage/accueil_page.dart';
import 'package:education/screen/Profil/avatar.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(key: Key('splash')),
        '/login': (context) => const LoginPage(key: Key('login')),
        '/OnboardingScreen': (context) => const OnboardingScreen(key: Key('OnboardingScreen')),
        '/register': (context) => const RegisterPage(key: Key('register')),
        '/editPass': (context) => const EditPassPage(key: Key('editPass')),
        //'/IntroPage': (context) => const IntroPage(key: Key('IntroPage')),
        '/FilierePage': (context) => const FilierePage(key: Key('FilierePage')),
//'/AvatarPage': (context) => const AvatarPage(key: Key('AvatarPage')),
        '/ObjectifPage': (context) => const ObjectifPage(key: Key('ObjectifPage')),
        '/ListFiliere': (context) => const ListFiliere(key: Key('ListFiliere')),
        '/AccueilPage': (context) => const AccueilPage(key: Key('AccueilPage')),
        '/AccueilMod': (context) => const AccueilMod(key: Key('AccueilMod')),
        '/AdAccueilPage': (context) => const AdAccueilPage(key: Key('AdAccueilPage')),
        '/AddFiliere': (context) => const AddFiliere(key: Key('AddFiliere')),
        //'/ObjectifPage': (context) => const ObjectifPage(key: Key('ObjectifPage')),
        '/AddQuiz': (context) => const AddQuiz(key: Key('AddQuiz')),
        '/AddCours': (context) => const AddCours(key: Key('AddCours')),
        '/ListFill': (context) => const ListFill(key: Key('ListFill')),
        '/ListObjectif': (context) => ListObjectif(),
        '/ListCours': (context) => ListCours(),
        '/ListQuiz': (context) => ListQuiz(),
        '/ListMod': (context) => ListMod(),
        '/AvatarPage': (context) => AvatarPage(
          onAvatarSelected: (String imagePath) {
            // Ajoutez ici le code à exécuter lorsque l'avatar est sélectionné
          },
        ),
      },
    );
  }
}
