import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Traitement extends StatefulWidget {
  const Traitement({Key? key}) : super(key: key);

  @override
  State<Traitement> createState() => _TraitementState();
}

class _TraitementState extends State<Traitement> {
  late File _image;
  late List _result;
  bool imageSelect = false;

  @override
  void initState() {
    super.initState();
    loadModel("assets/model_E.tflite", "assets/labelse.txt");
  }

  Future loadModel(String model, String labels) async {
    Tflite.close();
    await Future.delayed(Duration(milliseconds: 200));
    await Tflite.loadModel(
      model: model,
      labels: labels,
    );
    print("Model $model loaded");
  }

  Future imageClassification(File image) async {
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
      _result = recognitionsE! + recognitionsF!;
      _image = image;
      imageSelect = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emotion Recognition'),
      ),
      body: ListView(
        children: [
          (imageSelect)
              ? Container(
            margin: const EdgeInsets.all(10),
            child: Image.file(_image),
          )
              : Container(
            margin: const EdgeInsets.all(10),
            child: const Opacity(
              opacity: 0.8,
              child: Center(
                child: Text("No image selected"),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: (imageSelect)
                  ? _result.map((result) {
                return Card(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "${result['label']} - ${result['confidence'].toStringAsFixed(2)}",
                      style: const TextStyle(
                          color: Colors.red, fontSize: 20),
                    ),
                  ),
                );
              }).toList()
                  : [],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        tooltip: "Pick Image",
        child: const Icon(Icons.image),
      ),
    );
  }

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    File image = File(pickedFile!.path);
    imageClassification(image);
  }
}