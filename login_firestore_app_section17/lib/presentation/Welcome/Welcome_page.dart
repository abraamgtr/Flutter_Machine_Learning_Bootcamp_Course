import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_firestore_app_section17/data/mapper/PersonMapper.dart';
import 'package:login_firestore_app_section17/domain/entity/Person_entity.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required this.email});

  final String email;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  PersonEntity? person;
  PersonMapper _personMapper = PersonMapper();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 3), () async {
      person = await _personMapper.getPerson(
          personObject: PersonEntity(email: widget.email));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            person != null && person?.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.memory(
                      base64.decode(person?.image ?? ""),
                      height: 200.0,
                      width: 200.0,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(),
            Text(
              "Hello, ${person?.fullName}!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              "Want to join Us ?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: 50.0,
                width: 180.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(22.0)),
                    border: Border.all(
                      color: Colors.white,
                      width: 0.5,
                    )),
                child: Center(
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
