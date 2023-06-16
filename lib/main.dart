import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mapfe/Graph.dart';
import 'package:mapfe/Home.dart';
import 'package:mapfe/auth.dart';
import 'package:mapfe/chart_screen.dart';
import 'package:mapfe/mois_charts.dart';
import 'package:mapfe/statistique.dart';
import 'package:mapfe/traitement.dart';

import 'Connexion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Before using any firebase services, we need to initiate Firebase first
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'connection',
      routes: {
        'auth': (context) => const Auth(),
        'connection': (context) => const Connexion(),
        'home': (context) => const Home(),
        'graph': (context) =>  MyChartScreen(),
        'traitement': (context) => const Traitement(),
        'statistique': (context) =>  FirebaseDataScreen(),
      },
    );
  }
}
