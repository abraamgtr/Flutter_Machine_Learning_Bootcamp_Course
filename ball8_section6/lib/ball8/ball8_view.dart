import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ball8_bloc.dart';
import 'ball8_event.dart';
import 'ball8_state.dart';

class Ball8Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => Ball8Bloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<Ball8Bloc>(context);

    return Scaffold(
      body: BlocBuilder<Ball8Bloc, Ball8State>(
        builder: (ctx, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        "assets/images/8ball.jpg",
                        scale: 2.0,
                      ),
                      Positioned(
                          right: 0.0,
                          left: 0.0,
                          top: 80.0,
                          child: Center(
                              child: Container(
                            height: 120.0,
                            width: 120.0,
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0))),
                            child: Center(
                              child: Text(
                                state.randomNumber.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 120.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ))),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    state.luckyMessage ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  InkWell(
                    onTap: () => bloc.add(RollDiceEvent()),
                    child: Container(
                      height: 60.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Center(
                        child: Text(
                          "See your Luck!",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
