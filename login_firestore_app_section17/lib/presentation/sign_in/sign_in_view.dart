import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_firestore_app_section17/data/datasource/PersonDataSource.dart';
import 'package:login_firestore_app_section17/domain/entity/Person_entity.dart';
import 'package:login_firestore_app_section17/presentation/Welcome/Welcome_page.dart';
import 'package:login_firestore_app_section17/presentation/sign_in/sign_in_state.dart';

import 'sign_in_bloc.dart';
import 'sign_in_event.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignInBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _fullNameController = TextEditingController();
    TextEditingController _ageController = TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final bloc = BlocProvider.of<SignInBloc>(context);

    return Scaffold(
      body: BlocBuilder<SignInBloc, SignInState>(
        builder: (context, state) {
          if (state.isLogedIn == true) {
            Future.delayed(Duration(milliseconds: 300), () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => WelcomeScreen(
                      email: state.personObject?.email ?? "Test")));
            });
          } else if (state.isLogedIn == false) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Error in Signing you up!"),
              ),
            );
          }
          return Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Sign In",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            FontAwesomeIcons.facebook,
                            color: Colors.blue,
                            size: 40.0,
                          ),
                          IconButton(
                              onPressed: () {
                                PersonDataSource _personDataSource =
                                    PersonDataSource();
                                _personDataSource.signInWithGoogle();
                              },
                              icon: Icon(
                                FontAwesomeIcons.google,
                                color: Colors.red,
                                size: 40.0,
                              )),
                          Icon(
                            FontAwesomeIcons.linkedin,
                            color: Colors.blueAccent,
                            size: 40.0,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (email) {
                          if (email == null ||
                              !email.contains("@") ||
                              !email.contains(".")) {
                            return "Please enter valid email address!";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Email",
                          errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        controller: _fullNameController,
                        keyboardType: TextInputType.text,
                        validator: (name) {
                          if (name == null || name == "") {
                            return "Please your name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Test User",
                          errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        validator: (age) {
                          if (age == null || int.parse(age) <= 0) {
                            return "Please enter your age";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "12",
                          errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        validator: (password) {
                          if (password == null || password.length < 6) {
                            return "Please enter another password";
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Forgot Your Password",
                        style: TextStyle(color: Colors.grey, fontSize: 18.0),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            bloc.add(SignUpTriggerEvent(
                                personObject: PersonEntity(
                              email: _emailController.text,
                              fullName: _fullNameController.text,
                              age: _ageController.text.toString(),
                            )));
                          }
                        },
                        child: Container(
                          height: 50.0,
                          width: 180.0,
                          decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(22.0))),
                          child: Center(
                            child: Text(
                              "SIGN IN",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
