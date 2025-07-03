import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:section16_med_reminder/feature/Pills/add_pills.dart';
import 'package:section16_med_reminder/feature/home/index.dart';
import 'package:section16_med_reminder/main.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeBloc = HomeBloc(UnHomeState());
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentIndex == 0
          ? HomeScreen(homeBloc: _homeBloc)
          : AddPillScreen(homeBloc: _homeBloc),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Colors.purple,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(FontAwesomeIcons.pills),
            title: Text("Profile"),
            selectedColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}
