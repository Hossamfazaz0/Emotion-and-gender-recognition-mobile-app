import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/login.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
    body: SingleChildScrollView(
    child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130, right: 35),
              child: const Text(
                'Acceuil',
                style: TextStyle(color: Colors.white, fontSize: 50),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.5,
                right: 50,
                left: 50,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'traitement');
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.amberAccent,
                      child: Text(
                        'Charge image',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'graph');
                      // Handle Graphique button tap
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      child: Text(
                        'Graphe',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.7,
                right: 50,
                left: 50,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'statistique');
                      // Handle Statistique button tap
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      child: Text(
                        'Statistiques',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      exit(0);
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.amberAccent,
                      child: Text(
                        'Quitter',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
                ) ),
      ),
    );
  }
}