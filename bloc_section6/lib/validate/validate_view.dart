import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'validate_bloc.dart';
import 'validate_event.dart';
import 'validate_state.dart';

class ValidatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ValidateBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<ValidateBloc>(context);
    TextEditingController _emailController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocBuilder<ValidateBloc, ValidateState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                        color: state.isValid == true
                            ? Colors.green
                            : Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(50.0))),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      bloc.add(CheckForValidationEvent(
                          email: _emailController.text));
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
                    state.validationMessage ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color:
                          (state.isValid ?? false) ? Colors.green : Colors.red,
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
