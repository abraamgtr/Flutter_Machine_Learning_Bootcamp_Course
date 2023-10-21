import 'package:flutter/material.dart';
import 'package:weather_app_section11/feature/Home_page.dart';
import 'package:weather_app_section11/feature/home_bloc.dart';
import 'package:weather_app_section11/feature/home_state.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeBloc = HomeBloc(HomeInitial());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('London Weather'),
      ),
      body: HomePage(homeBloc: _homeBloc),
    );
  }
}
