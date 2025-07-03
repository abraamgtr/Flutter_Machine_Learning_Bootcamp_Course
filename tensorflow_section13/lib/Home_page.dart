import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late InputImage inputImage = InputImage.fromFile(File(""));
  late ImageLabeler imageLabeler;
  String prediction = "";
  String imageFilePath = "images/banana.jpg";
  bool _loading = false;

  Future<File> _getImageFileFromAssets(String path) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = "$tempPath/$path";
    var file = File(filePath);
    if (file.existsSync()) {
      return file;
    } else {
      final byteData = await rootBundle.load('assets/$path');
      final buffer = byteData.buffer;
      await file.create(recursive: true);
      return file.writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
  }

  Future<String> getModelPath(String asset) async {
    final path =
        '${(await getApplicationSupportDirectory()).path}/assets/$asset';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  @override
  void initState() {
    super.initState();
    // final ImageLabelerOptions options =
    //     ImageLabelerOptions(confidenceThreshold: 0.5);
    // imageLabeler = ImageLabeler(options: options);

    Future.delayed(const Duration(microseconds: 3), () async {
      // get model file
      final modelPath =
          await getModelPath('assets/models/object_labeler.tflite');
      final options = LocalLabelerOptions(
        modelPath: modelPath,
        maxCount: 20,
      );
      imageLabeler = ImageLabeler(options: options);

      // get image file
      File imageFile = await _getImageFileFromAssets(imageFilePath);
      inputImage = InputImage.fromFile(imageFile);
      setState(() {});
    });
  }

  @override
  void dispose() {
    imageLabeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.withOpacity(0.3),
        title: Text("Flutter Object Detector"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              !_loading
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Colors.deepOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                                width: 2.0,
                                color: Colors.deepOrange.withOpacity(0.5))),
                        child: Image.asset(
                          "assets/$imageFilePath",
                          fit: BoxFit.contain,
                          scale: 3,
                        ),
                      ),
                    )
                  : CircularProgressIndicator(),
              SizedBox(
                height: 12.0,
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                        width: 2.0, color: Colors.purple.withOpacity(0.5))),
                // child: Text(
                //   prediction,
                //   textAlign: TextAlign.center,
                //   maxLines: 10,
                //   style: TextStyle(
                //     fontSize: 20.0,
                //     fontWeight: FontWeight.bold,
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // ),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "Detected Image is\t",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                              text: prediction,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                              )),
                        ])),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            _loading = !_loading;
          });
          await Future.delayed(Duration(seconds: 2), () {});
          final List<ImageLabel> labels =
              await imageLabeler.processImage(inputImage);
          Map<String, dynamic> predictionResult = {
            "confidence": 0.0,
            "label": "",
          };
          for (ImageLabel label in labels) {
            final String text = label.label;
            final int index = label.index;
            final double confidence = label.confidence;

            if (predictionResult["confidence"] < confidence) {
              predictionResult["confidence"] = confidence;
              predictionResult["label"] = text;
            }

            print('Image text = ${text} Confidence = ${confidence}');
            prediction =
                "${predictionResult["label"]} with Confidence of ${(predictionResult["confidence"] * 100).toStringAsFixed(2)} %";
            setState(() {
              _loading = !_loading;
            });
          }
        },
        child: Center(
          child: Icon(
            Icons.search,
            color: Colors.purple,
            size: 40.0,
          ),
        ),
      ),
    );
  }
}
