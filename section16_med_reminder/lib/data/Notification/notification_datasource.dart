import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:section16_med_reminder/data/Notification/notification_dto.dart';
import 'dart:developer';

abstract class NotificationDataSource {
  Future<List<NotificationModel>?> getMedicineNotifications();
  Future<void> scheduleNotification({required NotificationDTO notificationDTO});
}

class NotificationDataSourceImpl extends NotificationDataSource {
  @override
  Future<void> scheduleNotification(
      {required NotificationDTO notificationDTO}) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await scheduleNotifications(
        title: 'Reminder for ${notificationDTO.type}',
        msg: "Don't forget your pill",
        heroThumbUrl:
            'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
        notificationDate: notificationDTO.pillTime!,
        repeatNotif: false,
        payload: {"type": notificationDTO.type ?? ""});
  }

  static Future<bool> displayNotificationRationale() async {
    bool isAllowed =
        await AwesomeNotifications().requestPermissionToSendNotifications();

    return isAllowed;
  }

  @override
  Future<List<NotificationModel>?> getMedicineNotifications() async {
    List<NotificationModel> notifications =
        await AwesomeNotifications().listScheduledNotifications();

    List<NotificationModel> medicineNotifications = [];

    notifications.forEach((notification) {
      if (notification.content?.payload?['type'] == "medicine" &&
          notification.schedule?.toMap()["day"].toString() ==
              DateTime.now().day.toString()) {
        DateTime? notifDate = DateTime(
            int.parse(notification.schedule?.toMap()["year"].toString() ?? ""),
            int.parse(notification.schedule?.toMap()["month"].toString() ?? ""),
            int.parse(notification.schedule?.toMap()["day"].toString() ?? ""),
            int.parse(notification.schedule?.toMap()["hour"].toString() ?? ""),
            int.parse(
                notification.schedule?.toMap()["minute"].toString() ?? ""),
            int.parse(
                notification.schedule?.toMap()["second"].toString() ?? ""));
        if (DateTime.now().isBefore(notifDate)) {
          medicineNotifications.add(notification);
        }
      }
    });

    medicineNotifications.sort((a, b) {
      DateTime? aDate = DateTime(
          int.parse(a.schedule?.toMap()["year"].toString() ?? ""),
          int.parse(a.schedule?.toMap()["month"].toString() ?? ""),
          int.parse(a.schedule?.toMap()["day"].toString() ?? ""),
          int.parse(a.schedule?.toMap()["hour"].toString() ?? ""),
          int.parse(a.schedule?.toMap()["minute"].toString() ?? ""),
          int.parse(a.schedule?.toMap()["second"].toString() ?? ""));
      DateTime? bDate = DateTime(
          int.parse(b.schedule?.toMap()["year"].toString() ?? ""),
          int.parse(b.schedule?.toMap()["month"].toString() ?? ""),
          int.parse(b.schedule?.toMap()["day"].toString() ?? ""),
          int.parse(b.schedule?.toMap()["hour"].toString() ?? ""),
          int.parse(b.schedule?.toMap()["minute"].toString() ?? ""),
          int.parse(b.schedule?.toMap()["second"].toString() ?? ""));

      return aDate.compareTo(bDate);
    });

    log("med Notifications = $medicineNotifications");

    if (medicineNotifications.isEmpty) {
      return null;
    } else {
      return medicineNotifications;
    }
  }

  Future<void> scheduleNotifications({
    required DateTime notificationDate,
    required String heroThumbUrl,
    required String title,
    required String msg,
    bool repeatNotif = false,
    Map<String, String?>? payload,
  }) async {
    await AwesomeNotifications().createNotification(
      schedule: NotificationCalendar.fromDate(
        date: notificationDate,
      )..allowWhileIdle = true,
      content: NotificationContent(
        id: DateTime.now().millisecond,
        channelKey: 'medicine_channel',
        criticalAlert: true,
        title: '${Emojis.food_bowl_with_spoon} $title',
        body: msg,
        bigPicture: heroThumbUrl,
        notificationLayout: NotificationLayout.BigPicture,

        //actionType : ActionType.DismissAction,
        color: Colors.black,
        backgroundColor: Colors.black,
        // customSound: 'resource://raw/notif',
        payload: payload,
      ),
      actionButtons: [],
    );
  }
}
