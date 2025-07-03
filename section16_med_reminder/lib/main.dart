import 'package:flutter/material.dart';
import 'package:section16_med_reminder/domain/notification/notification_usecase.dart';
import 'package:section16_med_reminder/feature/Pills/add_pills.dart';
import 'package:section16_med_reminder/feature/home/home_bloc.dart';
import 'package:section16_med_reminder/feature/home/home_page.dart';
import 'package:section16_med_reminder/feature/home/home_state.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
 var currentIndex = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationUsecaseImpl().initialize();
  runApp(MaterialApp(
    key: navigatorKey,
    debugShowCheckedModeBanner: false,
    routes: {
      "/home": (context) => HomePage(),
      '/addPills': (context) =>
          AddPillScreen(homeBloc: HomeBloc(InHomeState("test"))),
    },
    home: HomePage(),
  ));
}
