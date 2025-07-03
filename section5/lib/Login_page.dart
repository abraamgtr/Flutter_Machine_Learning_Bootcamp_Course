import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool revealPassword = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextStyle textfieldsStyle() {
    return TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Sign in",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (emailString) {
                                if (emailString == null ||
                                    emailString.isEmpty ||
                                    !emailString.contains("@")) {
                                  return "Please enter some valid email address";
                                }
                                return null;
                              },
                              style: textfieldsStyle(),
                              decoration: InputDecoration(
                                errorStyle: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                                hintText: "email",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (passwordString) {
                                if (passwordString == null ||
                                    passwordString.isEmpty) {
                                  return "Please enter some valid password";
                                }
                                if (passwordString.length < 6) {
                                  return "Please enter stronger password";
                                }
                                return null;
                              },
                              obscureText: !revealPassword,
                              style: textfieldsStyle(),
                              decoration: InputDecoration(
                                  // contentPadding: EdgeInsets.all(12.0),
                                  errorStyle: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                  hintText: "1234",
                                  suffixIcon: IconButton(
                                    padding: EdgeInsets.all(0.0),
                                    onPressed: () {
                                      setState(() {
                                        revealPassword = !revealPassword;
                                      });
                                    },
                                    icon: Icon(
                                      revealPassword == false
                                          ? Icons.remove_red_eye
                                          : Icons.add_alert_sharp,
                                      size: 30.0,
                                    ),
                                  ),
                                  border: OutlineInputBorder()),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 8.0,
                  ),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                      }
                    },
                    child: Container(
                      height: 60.0,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Center(
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "Forgot your password?",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    "Don't have a Column account?",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4.0,
                        child: Container(
                          height: 60.0,
                          width: double.infinity,
                          margin: EdgeInsets.only(left: 20.0, right: 20.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Center(
                            child: Text(
                              "Create new account",
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
