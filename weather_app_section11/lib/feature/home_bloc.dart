import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:weather_app_section11/feature/home_event.dart';
import 'package:weather_app_section11/feature/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(HomeState initialState) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      return emit.forEach<HomeState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error',
              name: 'HomeBloc', error: error, stackTrace: stackTrace);
          return ErrorHomeState(error.toString());
        },
      );
    });
  }
}
