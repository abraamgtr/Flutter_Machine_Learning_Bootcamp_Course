import 'package:animations_zerohero/Explicit_animation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Zero_Hero animations'),
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
  bool showGifAnimations = false;
  bool showAnimation = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  showGifAnimations = !showGifAnimations;
                });
              },
              icon: Icon(Icons.animation))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: showGifAnimations ? gifAnimations() : flutterAnimations(),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  flutterAnimations() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ExplicitAnimation(),
                  ));
                },
                icon: Icon(
                  Icons.skip_next,
                  size: 100.0,
                  color: Colors.blue,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    showAnimation = !showAnimation;
                  });
                },
                icon: Icon(
                  Icons.play_circle,
                  size: 100.0,
                  color: Colors.red,
                ))
          ],
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInQuad,
          height: showAnimation ? 200.0 : 0.0,
          width: showAnimation ? 300.0 : 0.0,
          child: Container(
            color: Colors.cyan,
          ),
        )
      ],
    );
  }

  gifAnimations() {
    return Column(
      children: [
        Card(
          elevation: 8.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              "assets/gifs/test.gif",
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Lottie.asset('assets/lottie/test.json', height: 100.0, width: 100.0),
      ],
    );
  }
}
