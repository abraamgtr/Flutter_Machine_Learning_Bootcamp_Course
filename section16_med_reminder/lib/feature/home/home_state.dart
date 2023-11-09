import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  HomeState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnHomeState extends HomeState {

  UnHomeState();

  @override
  String toString() => 'UnHomeState';
}

/// Initialized
class InHomeState extends HomeState {
  InHomeState(this.hello);
  
  final String hello;

  @override
  String toString() => 'InHomeState $hello';

  @override
  List<Object> get props => [hello];
}

class LoadHomeState extends HomeState {
  LoadHomeState();

  @override
  String toString() => 'LoadHomeState';

  @override
  List<Object> get props => [];
}
class NotifData extends HomeState {
  NotifData(this.nextTime);
  
  final Duration? nextTime;

  @override
  String toString() => 'NotifData';

  @override
  List<Object> get props => [nextTime ?? Duration()];
}

class ErrorHomeState extends HomeState {
  ErrorHomeState(this.errorMessage);
 
  final String errorMessage;
  
  @override
  String toString() => 'ErrorHomeState';

  @override
  List<Object> get props => [errorMessage];
}
