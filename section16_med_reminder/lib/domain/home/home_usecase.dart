import 'package:section16_med_reminder/data/home/home_datasource.dart';
import 'package:section16_med_reminder/domain/home/home_entity.dart';

abstract class HomeUsecase {
  Future<HomeEntity?> getNextNotification();
  HomeDataSourceImpl _homeDataSourceImpl = HomeDataSourceImpl();
}

class HomeUsecaseImpl extends HomeUsecase {
  @override
  // TODO: implement _homeDataSourceImpl
  HomeDataSourceImpl get _homeDataSourceImpl => HomeDataSourceImpl();
  @override
  Future<HomeEntity?> getNextNotification() async {
    Duration? nextNotifTime = await _homeDataSourceImpl.getNextNotificationTime();

    HomeEntity? homeEntity =
        HomeEntity(nextTime: nextNotifTime ?? Duration(seconds: 1));

    return homeEntity;
  }
}
