import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_app_section11/domain/Home/Home_entity.dart';
import 'package:weather_app_section11/domain/Home/Home_usecase.dart';
import 'package:weather_app_section11/feature/home_bloc.dart';
import 'package:weather_app_section11/feature/home_state.dart';

@immutable
abstract class HomeEvent {
  Stream<HomeState> applyAsync({HomeState? currentState, HomeBloc? bloc});
}

class HomeInitEvent extends HomeEvent {
  @override
  Stream<HomeState> applyAsync(
      {HomeState? currentState, HomeBloc? bloc}) async* {}
}

class HomeLoadingEvent extends HomeEvent {
  @override
  Stream<HomeState> applyAsync(
      {HomeState? currentState, HomeBloc? bloc}) async* {
    yield HomeInitial();
  }
}

class HomeDataWeatherEvent extends HomeEvent {
  HomeUsecaseImpl _homeUsecaseImpl = HomeUsecaseImpl();
  List<HomeEntity>? forecastList = [];
  @override
  Stream<HomeState> applyAsync(
      {HomeState? currentState, HomeBloc? bloc}) async* {
    yield HomeInitial();

    forecastList = await _homeUsecaseImpl.getForecastList();
    print("Data = $forecastList");

    if (forecastList != null && (forecastList?.length ?? 0) > 0) {
      yield HomeData(forecastList: forecastList);
    } else {
      yield ErrorHomeState("We can not get weather Data");
    }
  }
}
