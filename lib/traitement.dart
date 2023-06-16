import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reconnaissance des émotions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Traitement(),
    );
  }
}

class Traitement extends StatefulWidget {
  const Traitement({Key? key}) : super(key: key);

  @override
  State<Traitement> createState() => _TraitementState();
}

class _TraitementState extends State<Traitement> {
  late File _image;
  late List _result;
  bool _imageSelected = false;

  @override
  void initState() {
    super.initState();
    loadModel("assets/model_E.tflite", "assets/labelse.txt");
    Firebase.initializeApp();
  }

  Future<void> loadModel(String model, String labels) async {
    Tflite.close();
    await Future.delayed(const Duration(milliseconds: 200));
    await Tflite.loadModel(
      model: model,
      labels: labels,
    );
    print("Modèle $model chargé");
  }

  Future<void> imageClassification(File image) async {
    var recognitionsE = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    await loadModel("assets/model_S.tflite", "assets/labelss.txt");
    var recognitionsF = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _result = (recognitionsE! + recognitionsF!)!;
      _image = image;
      _imageSelected = true;
    });
    DateTime currentDate = DateTime.now();
    String currentMonthName = DateFormat('MMMM').format(currentDate);
    String currentDayName = DateFormat('EEEE').format(currentDate);
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // Stocker les données dans la collection Firestore
    await FirebaseFirestore.instance.collection('data').add({
      "Gender": _result[1]['label'],
      "Emotion": _result[0]['label'],
      "Mois_date": currentMonthName,
      "Jour_date": currentDayName,
      "Date": formattedDate
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reconnaissance des émotions'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _imageSelected
                  ? Container(
                margin: const EdgeInsets.all(10),
                child: Image.file(_image),
              )
                  : Container(
                margin: const EdgeInsets.all(10),
                child: Opacity(
                  opacity: 0.8,
                  child: Center(
                    child: const Text("Aucune image sélectionnée"),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _imageSelected
                      ? _result.map((result) {
                    return Card(
                      child: ListTile(
                        title: Text(
                          "${result['label']}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          "Confiance : ${result['confidence'].toStringAsFixed(2)}",
                        ),
                      ),
                    );
                  }).toList()
                      : [],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        tooltip: "Sélectionner une image",
        child: const Icon(Icons.image),
      ),
    );
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    File image = File(pickedFile!.path);
    imageClassification(image);
  }
}
