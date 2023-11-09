import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:remote_notification_section16/Home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
