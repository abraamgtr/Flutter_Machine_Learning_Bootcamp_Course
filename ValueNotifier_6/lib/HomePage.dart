import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  ValueNotifier<int> _counterChanged = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ValueListenableBuilder<int>(
          valueListenable: _counterChanged,
          builder: (ctx, value, child) {
            return Text(
              "Counter is = $value",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          _counter++;
          _counterChanged.value = _counter;
        },
        icon: Icon(
          Icons.add,
          color: Colors.purpleAccent,
          size: 50.0,
        ),
      ),
    );
  }
}
