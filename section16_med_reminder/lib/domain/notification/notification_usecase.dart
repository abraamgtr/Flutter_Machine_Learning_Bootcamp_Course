import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:section16_med_reminder/data/Notification/notification_datasource.dart';
import 'package:section16_med_reminder/data/Notification/notification_dto.dart';
import 'package:section16_med_reminder/domain/notification/notification_entity.dart';

abstract class NotificationUseCase {
  Future<void>? initialize();
  Future<void> getMedicineNotifications();
  Future<void> getBactriumNotifications();
  Future<void> getHealerNotifications();
  Future<void> scheduleNotification(
      {required NotificationEntity notificationEntity});
  NotificationDataSourceImpl _notificationDataSourceImpl =
      NotificationDataSourceImpl();
}

class NotificationUsecaseImpl extends NotificationUseCase {
  static ReceivedAction? initialAction;
  @override
  NotificationDataSourceImpl get _notificationDataSourceImpl =>
      NotificationDataSourceImpl();
  @override
  Future<void>? initialize() async {
    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        //'resource://drawable/res_app_icon',
        null,
        [
          NotificationChannel(
              channelGroupKey: 'medicine_channel_group',
              channelKey: 'medicine_channel',
              playSound: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              channelName: 'Medicine notifications',
              channelDescription: 'Notification channel for medicine reminder',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.white)
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'medicine_channel_group',
              channelGroupName: 'Medicine group')
        ],
        debug: true);

    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  @override
  Future<void> getMedicineNotifications() async {
    await _notificationDataSourceImpl.getMedicineNotifications();
  }

  @override
  Future<void> scheduleNotification(
      {required NotificationEntity notificationEntity}) async {
    NotificationDTO notificationData =
        NotificationDTO.fromJson(notificationEntity.toJson());
    await _notificationDataSourceImpl.scheduleNotification(
        notificationDTO: notificationData);
  }

  @override
  Future<void> getBactriumNotifications() {
    // TODO: implement getBactriumNotifications
    throw UnimplementedError();
  }

  @override
  Future<void> getHealerNotifications() {
    // TODO: implement getHealerNotifications
    throw UnimplementedError();
  }
}
