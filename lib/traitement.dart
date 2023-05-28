import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class Traitement extends StatefulWidget {
  const Traitement({Key? key}) : super(key: key);

  @override
  State<Traitement> createState() => _TraitementState();
}

class _TraitementState extends State<Traitement> {
  Interpreter? _interpreter;
  bool _modelLoaded = false;
  List<String> _emotionLabels = ['Happy', 'Sad', 'Angry'];
  String? _currentEmotion;

  Future<String?> openImagePicker() async {
    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      return pickedImage.path;
    } else {
      // User canceled the picker
      return null;
    }
  }

  Future<void> loadModel() async {
    try {
      // Load the TFLite model file
      final interpreterOptions = InterpreterOptions();
      final interpreter = await Interpreter.fromAsset(
        'assets/model_E.tflite',
        options: interpreterOptions,
      );

      setState(() {
        _interpreter = interpreter;
        _modelLoaded = true; // Model is loaded successfully
      });

      print('Model loaded successfully');
    } catch (e) {
      print('Failed to load TFLite model: $e');
    }
  }

  Future<void> applyEmotionRecognition(String imagePath) async {
    try {
      if (!_modelLoaded) {
        print('TFLite model is not loaded yet.');
        return;
      }

      // Load and preprocess the image
      final image = await loadImage(imagePath);
      final preprocessedImage = preprocessImage(image);

      // Run inference
      final outputs = await runInference(preprocessedImage);

      // Process the model outputs
      final predictedEmotionIndex = processEmotionOutputs(outputs);
      setState(() {
        _currentEmotion = _emotionLabels[predictedEmotionIndex];
      });
    } catch (e) {
      print('Error applying emotion recognition: $e');
    }
  }

  Future<Uint8List> loadImage(String imagePath) async {
    final file = File(imagePath);
    return await file.readAsBytes();
  }

  Uint8List preprocessImage(Uint8List image) {
    // Apply preprocessing steps to the image
    // Convert image to desired format, resize, normalize, etc.
    // Return the preprocessed image as a Uint8List
    return image;
  }

  Future<List<List<dynamic>>> runInference(Uint8List preprocessedImage) async {
    final inputs = [preprocessedImage];

    final outputs = <List<dynamic>>[];
    _interpreter?.run(inputs, outputs);

    return outputs;
  }

  int processEmotionOutputs(List<List<dynamic>> outputs) {
    // Process the model outputs to obtain the predicted emotions
    // You'll need to analyze the output data based on the specific format
    // and interpretation of the emotion recognition model
    // Here's an example of how you can print the output values:
    double maxScore = double.negativeInfinity;
    int maxIndex = 0;

    for (int i = 0; i < outputs[0].length; i++) {
      double score = outputs[0][i];
      if (score > maxScore) {
        maxScore = score;
        maxIndex = i;
      }
      print('Emotion value: $score');
    }

    return maxIndex;
  }

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emotion Recognition'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'pre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Select a date'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      // Do something with the picked date
                      print(pickedDate);
                    }
                  },
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _modelLoaded ? () async {
                      String? imagePath = await openImagePicker();
                      if (imagePath != null) {
                        // Do something with the selected image path
                        print(imagePath);

                        // Apply emotion recognition model to the image
                        await applyEmotionRecognition(imagePath);
                      }
                    } : null,
                    child: Text('Upload Photo'),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Current Emotion: ${_currentEmotion ?? 'Unknown'}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}