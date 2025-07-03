import 'dart:math';

import 'package:bloc/bloc.dart';

import 'ball8_event.dart';
import 'ball8_state.dart';

class Ball8Bloc extends Bloc<Ball8Event, Ball8State> {
  Ball8Bloc() : super(Ball8State()) {
    on<InitEvent>(_init);
    on<RollDiceEvent>(_rollDice);
  }

  void _init(InitEvent event, Emitter<Ball8State> emit) async {}

  void _rollDice(RollDiceEvent event, Emitter<Ball8State> emit) async {
    // 0 - 10
    int randomNumber = Random().nextInt(9);
    if (randomNumber % 2 == 0) {
      emit(state.copyWith(
        randomNumber: randomNumber,
        luckyMessage: "You are lucky let's do it",
      ));
    } else {
      emit(state.copyWith(
        randomNumber: randomNumber,
        luckyMessage: "You are not lucky today don't do it",
      ));
    }
  }
}
