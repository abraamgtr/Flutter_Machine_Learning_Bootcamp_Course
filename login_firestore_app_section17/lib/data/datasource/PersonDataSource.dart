import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_firestore_app_section17/data/dto/Person.dart';

abstract class PersonDataSourceBluePrint {
  Future<String?> addUser({required PersonDTO personObject});
  Future<PersonDTO?> getPerson({required PersonDTO personObject});
  Future<User?> signInWithGoogle();
}

class PersonDataSource extends PersonDataSourceBluePrint {
  PersonDataSource();

  Future<String?> convertToBase64() async {
    ByteData bytes = await rootBundle.load('assets/images/test.jpg');
    var buffer = bytes.buffer;
    var convertedImage = base64.encode(Uint8List.view(buffer));

    return convertedImage;
  }

  @override
  Future<String?> addUser({required PersonDTO personObject}) async {
    try {
      print("Entring = ${personObject.toJson()}");
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      String? convertedImage = await convertToBase64();
      // Call the user's CollectionReference to add a new user
      await users.doc(personObject.email).set({
        'fullName': personObject.fullName,
        'age': personObject.age,
        'image': convertedImage,
      });
      return 'Adding User Done!';
    } catch (e) {
      return 'Error adding user';
    }
  }

  Future<PersonDTO?> getPerson({required PersonDTO personObject}) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final snapshot = await users.doc(personObject.email).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return PersonDTO.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _googleSignIn.signOut();
    User? _user;
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    AuthCredential? credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    UserCredential? authResult = await _auth.signInWithCredential(credential);
    _user = authResult.user;
    assert(_user?.isAnonymous == false);
    assert(await _user?.getIdToken() != null);
    User? currentUser = await _auth.currentUser;
    assert(_user?.uid == currentUser?.uid);
    print("User Name: ${_user?.displayName}");
    print("User Email ${_user?.email}");
    return currentUser;
  }
}
