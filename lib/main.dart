// Import necessary packages
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ml_example/photo_chooser.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _recognizedText = '';
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ML Kit Example'),
      ),
      body: image == null?Center(
        child: ElevatedButton(
          onPressed: () {
            recognizeText();
          },
          child: const Text('Recognize Text'),
        ),
      ):Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 24),
          children: [
            Image.file(image!,height: 150,width: 150,),
            const SizedBox(height: 16,),
            Text(_recognizedText,style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
            const SizedBox(height: 16,),
            ElevatedButton(
              onPressed: () {
                image = null;
                _recognizedText = '';
                setState(() {

                });
              },
              child: const Text('clear'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> recognizeText() async {
    final TextRecognizer textRecognizer = GoogleMlKit.vision.textRecognizer();
    var result = await Get.bottomSheet(const PhotoChooser(),backgroundColor: Colors.white);
    final InputImage inputImage;
    print("tffyugvmvhj $result");
    if(result!=null) {
       inputImage = InputImage.fromFile(result);
       try {
         final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
         setState(() {
           image = result;
           _recognizedText = recognizedText.text;
         });
       } catch (e) {
         print('Error: $e');
       } finally {
         textRecognizer.close();
       }
    }
  }
}
