import 'package:equatable/equatable.dart';
import 'package:weather_app_section11/domain/Home/Home_entity.dart';

abstract class HomeState extends Equatable {
  HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeData extends HomeState {
  final List<HomeEntity>? forecastList;

  HomeData({this.forecastList});
}

class ErrorHomeState extends HomeState {
  ErrorHomeState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorHomeState';

  @override
  List<Object> get props => [errorMessage];
}
