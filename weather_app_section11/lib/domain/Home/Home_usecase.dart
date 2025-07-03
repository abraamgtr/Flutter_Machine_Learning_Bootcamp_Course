import 'package:weather_app_section11/data/Home/Home_mapper.dart';
import 'package:weather_app_section11/domain/Home/Home_entity.dart';

abstract class HomeUsecase {
  Future<List<HomeEntity>?> getForecastList();
}

class HomeUsecaseImpl extends HomeUsecase {
  @override
  Future<List<HomeEntity>?> getForecastList() async {
    HomeMapper _homeMapper = HomeMapper();

    List<HomeEntity>? forecastList = [];

    forecastList = await _homeMapper.getForecastList();

    return forecastList;
  }
}
