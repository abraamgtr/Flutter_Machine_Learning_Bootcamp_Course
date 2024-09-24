import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ExplicitAnimation extends StatefulWidget {
  const ExplicitAnimation({super.key});

  @override
  State<ExplicitAnimation> createState() => _ExplicitAnimationState();
}

class _ExplicitAnimationState extends State<ExplicitAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      lowerBound: 0,
      upperBound: 10,
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(1, 1),
    ).animate(_controller);

    _animation.addListener(() {
      print("animation value ${_animation.value}");
    });
    _controller.addListener(() {
      print("controller value ${_controller.value}");
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Explicit Animation Example')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    _controller.forward();
                  },
                  icon: Icon(
                    Icons.play_arrow,
                    size: 50.0,
                  )),
              IconButton(
                  onPressed: () {
                    _controller.stop();
                  },
                  icon: Icon(
                    Icons.pause,
                    size: 50.0,
                  )),
              IconButton(
                  onPressed: () {
                    _controller.reset();
                  },
                  icon: Icon(
                    Icons.lock_reset,
                    size: 50.0,
                  )),
            ],
          ),
          const SizedBox(
            height: 50.0,
          ),
          Animate(
            controller: _controller,
            child: Text("Animate Me",
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold)),
          ).scale().fade().color(begin: Colors.red, end: Colors.black),
        ],
      ),
    );
  }

  _explicitAnimations() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  _controller.forward();
                },
                icon: Icon(
                  Icons.play_arrow,
                  size: 50.0,
                )),
            IconButton(
                onPressed: () {
                  _controller.stop();
                },
                icon: Icon(
                  Icons.pause,
                  size: 50.0,
                )),
            IconButton(
                onPressed: () {
                  _controller.reset();
                },
                icon: Icon(
                  Icons.lock_reset,
                  size: 50.0,
                )),
          ],
        ),
        const SizedBox(
          height: 50.0,
        ),
        Slider(
          value: _controller.value,
          onChanged: (_) {},
          max: 10,
        ),
        SlideTransition(
          position: _animation,
          child: Center(child: FlutterLogo(size: 100)),
        ),
      ],
    );
  }
}
