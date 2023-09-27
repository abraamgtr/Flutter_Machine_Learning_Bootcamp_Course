import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_section6/Models/ValidationNotifier.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  TextEditingController _isValidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ValidationNotifier>(
      create: (ctx) => ValidationNotifier(),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Consumer<ValidationNotifier>(
              builder: (ctx, validationNotifier, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                          color: validationNotifier.isValid == true
                              ? Colors.green
                              : Colors.orange,
                          borderRadius:
                              BorderRadius.all(Radius.circular(50.0))),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      controller: _isValidController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        validationNotifier
                            .checkForValidation(_isValidController.text);
                      },
                      child: Container(
                        height: 50.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: Center(
                          child: Text(
                            "Check",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      validationNotifier.validationMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: validationNotifier.isValid
                            ? Colors.green
                            : Colors.red,
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
