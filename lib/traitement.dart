import 'dart:io';

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
  List<dynamic> _emotionResult = [];
  List<dynamic> _genderResult = [];
  bool _imageSelected = false;

  @override
  void initState() {
    super.initState();
    loadModels();
  }

  Future<void> loadModels() async {
    await Tflite.loadModel(
      model: 'assets/model_E.tflite',
      labels: 'assets/labelse.txt',
    );
    await Tflite.loadModel(
      model: 'assets/model_S.tflite',
      labels: 'assets/labelss.txt',
    );
    print('Models loaded successfully');
  }

  Future<void> classifyImage(File image) async {
    var emotionResult = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
      asynch: true,
    );

    var genderResult = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
      asynch: true,
    );

    setState(() {
      _emotionResult = emotionResult!;
      _genderResult = genderResult!;
      _image = image;
      _imageSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emotion and Gender Recognition'),
      ),
      body: ListView(
        children: [
          _imageSelected
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
          if (_imageSelected)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Emotion:",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
                ..._emotionResult.map((result) {
                  return Card(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Text(
                        "${result['label']} - ${result['confidence'].toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                SizedBox(height: 10),
                Text(
                  "Gender:",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                  ),
                ),
                ..._genderResult.map((result) {
                  return Card(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Text(
                        "${result['label']} - ${result['confidence'].toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        tooltip: "Pick Image",
        child: const Icon(Icons.image),
      ),
    );
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      classifyImage(image);
    }
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}