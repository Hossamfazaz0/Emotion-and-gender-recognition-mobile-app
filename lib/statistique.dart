import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Statistique extends StatefulWidget {
  const Statistique({Key? key}) : super(key: key);

  @override
  State<Statistique> createState() => _Statistique();
}

class _Statistique extends State<Statistique> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/login.png'), fit: BoxFit.cover)),
      child: Scaffold(
      appBar: AppBar(
        title: Text('statistique'),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Row(

              )
            ],
          ),
        ),
      ),
    ));
  }
}