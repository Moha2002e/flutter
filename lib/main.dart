import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projectexamen/l10n/app_localizations.dart';
import 'package:projectexamen/screens/WelcomeScreen.dart';
import 'package:projectexamen/screens/LoginScreen.dart';
import 'package:projectexamen/screens/RegisterScreen.dart';
import 'package:projectexamen/screens/HomeScreen.dart';
import 'package:projectexamen/screens/ProfileScreen.dart';
import 'package:projectexamen/screens/ClubsScreen.dart';
import 'package:projectexamen/screens/CreerClubScreen.dart';
import 'package:projectexamen/screens/ClubDetailScreen.dart';
import 'package:projectexamen/screens/AnnoncesScreen.dart';
import 'package:projectexamen/screens/CreerAnnonceScreen.dart';
import 'package:projectexamen/screens/EvenementsScreen.dart';
import 'package:projectexamen/screens/CreerEvenementScreen.dart';
import 'package:projectexamen/screens/CalendrierScreen.dart';
import 'package:projectexamen/screens/CreerCoursScreen.dart';
import 'package:projectexamen/screens/CoursDetailScreen.dart';
import 'package:projectexamen/screens/AnnonceDetailScreen.dart';
import 'package:projectexamen/screens/EvenementDetailScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase initialized successfully');
  } catch (e, stackTrace) {
    debugPrint('Firebase initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    // Ne pas continuer si Firebase n'est pas initialisé
    rethrow;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accueil CampusLink',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
      initialRoute: WelcomeScreen.routeName,
      routes: {
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        ClubsScreen.routeName: (context) => const ClubsScreen(),
        CreerClubScreen.routeName: (context) => const CreerClubScreen(),
        AnnoncesScreen.routeName: (context) => const AnnoncesScreen(),
        CreerAnnonceScreen.routeName: (context) => const CreerAnnonceScreen(),
        EvenementsScreen.routeName: (context) => const EvenementsScreen(),
        CreerEvenementScreen.routeName: (context) => const CreerEvenementScreen(),
        CalendrierScreen.routeName: (context) => const CalendrierScreen(),
        CreerCoursScreen.routeName: (context) => const CreerCoursScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == ClubDetailScreen.routeName) {
          final clubId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ClubDetailScreen(clubId: clubId),
          );
        }
        if (settings.name == CoursDetailScreen.routeName) {
          final coursId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => CoursDetailScreen(coursId: coursId),
          );
        }
        if (settings.name == AnnonceDetailScreen.routeName) {
          final annonceId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => AnnonceDetailScreen(annonceId: annonceId),
          );
        }
        if (settings.name == EvenementDetailScreen.routeName) {
          final evenementId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => EvenementDetailScreen(evenementId: evenementId),
          );
        }
        return null;
      },
    );
  }
}

