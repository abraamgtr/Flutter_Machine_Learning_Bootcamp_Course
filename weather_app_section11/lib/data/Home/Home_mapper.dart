import 'package:weather_app_section11/data/Home/Home_DTO.dart';
import 'package:weather_app_section11/data/Home/Home_Datasource.dart';
import 'package:weather_app_section11/domain/Home/Home_entity.dart';

abstract class HomeMapperAbstract {
  Future<List<HomeEntity>?> getForecastList();
}

class HomeMapper extends HomeMapperAbstract {
  @override
  Future<List<HomeEntity>?> getForecastList() async {
    HomeDataSource _homDataSource = HomeDataSource();
    List<HomeEntity>? forecastEntityList = [];
    try {
      List<HomeDTO>? forecastListDto = await _homDataSource.getWeather();

      if (forecastListDto != null && forecastListDto.isNotEmpty) {
        forecastListDto.forEach((homeDto) {
          forecastEntityList.add(HomeEntity.fromJson(homeDto.toJson()));
        });
        return forecastEntityList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
      print("INFO: ERROR => ${e.toString()}");
    }
  }
}
