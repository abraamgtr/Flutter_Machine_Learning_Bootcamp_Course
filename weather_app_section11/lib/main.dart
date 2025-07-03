import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_section11/feature/home_bloc.dart';
import 'package:weather_app_section11/feature/home_screen.dart';
import 'package:weather_app_section11/feature/home_state.dart';

void main() {
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (context) => HomeBloc(HomeInitial()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      )));
}
