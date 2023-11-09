import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:section16_med_reminder/data/Notification/notification_datasource.dart';

abstract class HomeDataSource {
  Future<Duration?> getNextNotificationTime();
  Future<Duration>? getNextNotificationToday(DateTime notifTime);
}

class HomeDataSourceImpl extends HomeDataSource {
  @override
  Future<Duration>? getNextNotificationToday(DateTime notifTime) async {
    Duration timeDifference = notifTime.difference(DateTime.now());

    return timeDifference;
  }

  @override
  Future<Duration?> getNextNotificationTime() async {
    NotificationDataSourceImpl _notificationDatasource =
        NotificationDataSourceImpl();

    List<NotificationModel>? notifications =
        await _notificationDatasource.getMedicineNotifications();

    if (notifications != null && notifications.isNotEmpty) {
      DateTime? nextNotifDate = DateTime(
          int.parse(
              notifications.first.schedule?.toMap()["year"].toString() ?? ""),
          int.parse(
              notifications.first.schedule?.toMap()["month"].toString() ?? ""),
          int.parse(
              notifications.first.schedule?.toMap()["day"].toString() ?? ""),
          int.parse(
              notifications.first.schedule?.toMap()["hour"].toString() ?? ""),
          int.parse(
              notifications.first.schedule?.toMap()["minute"].toString() ?? ""),
          int.parse(
              notifications.first.schedule?.toMap()["second"].toString() ??
                  ""));

      Duration? nextNotifString = await getNextNotificationToday(nextNotifDate);

      print("Difference = ${nextNotifString}");
     

      return nextNotifString;
    }

    return null;
  }
}
