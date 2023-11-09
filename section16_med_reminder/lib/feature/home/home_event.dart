import 'dart:async';
import 'dart:developer' as developer;

import 'package:section16_med_reminder/data/home/home_datasource.dart';
import 'package:section16_med_reminder/domain/home/home_entity.dart';
import 'package:section16_med_reminder/domain/home/home_usecase.dart';
import 'package:section16_med_reminder/domain/notification/notification_entity.dart';
import 'package:section16_med_reminder/domain/notification/notification_usecase.dart';
import 'package:section16_med_reminder/feature/home/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent {
  Stream<HomeState> applyAsync({HomeState currentState, HomeBloc bloc});
  HomeUsecaseImpl _homeUsecaseImpl = HomeUsecaseImpl();
  NotificationUsecaseImpl _notificationUsecaseImpl = NotificationUsecaseImpl();
}

class UnHomeEvent extends HomeEvent {
  @override
  Stream<HomeState> applyAsync(
      {HomeState? currentState, HomeBloc? bloc}) async* {
    yield UnHomeState();
  }
}

class LoadHomeEvent extends HomeEvent {
  @override
  Stream<HomeState> applyAsync(
      {HomeState? currentState, HomeBloc? bloc}) async* {
    try {
      yield UnHomeState();
      await Future.delayed(const Duration(seconds: 1));
      yield InHomeState('Hello world');
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadHomeEvent', error: _, stackTrace: stackTrace);
      yield ErrorHomeState(_.toString());
    }
  }
}

class LoadHomeNotifEvent extends HomeEvent {
  @override
  // TODO: implement _homeDataSourceImpl
  HomeUsecaseImpl get _homeUsecaseImpl => HomeUsecaseImpl();
  late Timer _timer;

  @override
  Stream<HomeState> applyAsync(
      {HomeState? currentState, HomeBloc? bloc}) async* {
    try {
      yield LoadHomeState();
      HomeEntity? homeNotifications =
          await _homeUsecaseImpl.getNextNotification();

      if (homeNotifications != null && homeNotifications.nextTime != null) {
        if (homeNotifications.nextTime!.inSeconds != 1) {
          Future.delayed(homeNotifications.nextTime!, () async {
            bloc?.add(LoadHomeNotifEvent());
          });
        }

        yield NotifData(homeNotifications.nextTime);
      } else {
        yield InHomeState("init");
      }
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadHomeEvent', error: _, stackTrace: stackTrace);
      yield ErrorHomeState(_.toString());
    }
  }
}

class ScheduleHomeNotifEvent extends HomeEvent {
  @override
  // TODO: implement _homeDataSourceImpl
  HomeUsecaseImpl get _homeUsecaseImpl => HomeUsecaseImpl();
  @override
  // TODO: implement _notificationUsecaseImpl
  NotificationUsecaseImpl get _notificationUsecaseImpl =>
      NotificationUsecaseImpl();

  ScheduleHomeNotifEvent({required this.notificationData});

  NotificationEntity notificationData;

  @override
  Stream<HomeState> applyAsync(
      {HomeState? currentState, HomeBloc? bloc}) async* {
    try {
      yield LoadHomeState();
      await _notificationUsecaseImpl.scheduleNotification(
          notificationEntity: notificationData);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadHomeEvent', error: _, stackTrace: stackTrace);
      yield ErrorHomeState(_.toString());
    }
  }
}
