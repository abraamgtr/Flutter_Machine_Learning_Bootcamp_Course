import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:imgae_gallery_section9/Camera_page.dart';

late List<CameraDescription> _cameras;
Color greenColor = Color(0xff005B41);
List<XFile> pictures = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Camera App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//!controller.value.isInitialized

  Future<void> _takePicture() async {
    XFile takenPicture = await Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => CameraPage(cameras: _cameras)));
    pictures.add(takenPicture);
    print("Taken picture lengths = ${pictures.length}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenColor,
      appBar: AppBar(
        backgroundColor: greenColor,
        actions: [
          IconButton(
              onPressed: () async {
                await _takePicture();
              },
              icon: Icon(
                Icons.add_box_rounded,
                color: Colors.white,
                size: 50.0,
              ))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Image Gallery",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              margin: EdgeInsets.only(top: 30.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0))),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recently Added",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Expanded(
                        child: pictures.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      "No Images\nLet's Take some Image",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: greenColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30.0),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await _takePicture();
                                    },
                                    child: Card(
                                      elevation: 8.0,
                                      child: Container(
                                        height: 60.0,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: greenColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Center(
                                          child: Text(
                                            "Take A Picture",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : GridView.builder(
                                itemCount: pictures.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 20.0),
                                itemBuilder: (ctx, index) {
                                  return ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    child: Image.file(
                                      File(pictures[index].path),
                                      height: 60.0,
                                      width: 60.0,
                                      fit: BoxFit.fill,
                                    ),
                                  );
                                }))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
