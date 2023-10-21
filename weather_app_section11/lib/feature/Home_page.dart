import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_section11/feature/home_bloc.dart';
import 'package:weather_app_section11/feature/home_event.dart';
import 'package:weather_app_section11/feature/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required HomeBloc homeBloc})
      : _homeBloc = homeBloc,
        super(key: key);

  final HomeBloc _homeBloc;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 3), () {
      widget._homeBloc.add(HomeDataWeatherEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        bloc: widget._homeBloc,
        builder: (ctx, state) {
          if (state is HomeInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ErrorHomeState) {
            return Center(
              child: Text(
                state.errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            );
          } else if (state is HomeData) {
            return Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        "http://openweathermap.org/img/w/${state.forecastList?.first.icon}.png",
                        scale: 0.2,
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Center(
                      child: Text(
                        (state.forecastList?.first.temp ?? 0.0).toString() +
                            "\t°C",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wind_power,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            (state.forecastList?.first.windSpeed ?? 0.0)
                                    .toString() +
                                "km/h",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(child: Container()),
                          Icon(
                            Icons.heat_pump_outlined,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            (state.forecastList?.first.humidity ?? 0.0)
                                    .toString() +
                                "%",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: state.forecastList?.map<Widget>((e) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 20.0,
                                  width: 20.0,
                                  decoration: BoxDecoration(
                                    color: Colors.cyan,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(100.0)),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      (e.temp ?? 0.0).toString() + "\t°C",
                                      style: TextStyle(
                                        color: Colors.cyan,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      e.day.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }).toList() ??
                        [],
                  ),
                )),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
