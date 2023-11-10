import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:section16_med_reminder/Utils/AppColor.dart';
import 'package:section16_med_reminder/domain/notification/notification_usecase.dart';
import 'package:section16_med_reminder/feature/home/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required HomeBloc homeBloc,
    Key? key,
  })  : _homeBloc = homeBloc,
        super(key: key);

  final HomeBloc _homeBloc;

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  HomeScreenState();
  AppColor _appColor = AppColor();
  NotificationUsecaseImpl _notificationUsecaseImpl = NotificationUsecaseImpl();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2), () async {
      widget._homeBloc.add(LoadHomeNotifEvent());
    });
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
        bloc: widget._homeBloc,
        builder: (
          BuildContext context,
          HomeState currentState,
        ) {
          if (currentState is UnHomeState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorHomeState) {
            return Text("Error");
          }
          if (currentState is InHomeState || currentState is NotifData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 60.0, 12.0, 0.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Image.asset(
                              "assets/images/user.jpg",
                              scale: 25,
                              fit: BoxFit.cover,
                            )),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Hello, Joanna",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Your medicines for",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: "\t\ttoday",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold)),
                          ])),
                      SizedBox(
                        height: 20.0,
                      ),
                      BlocBuilder<HomeBloc, HomeState>(
                          bloc: widget._homeBloc,
                          builder: (ctx, state) {
                            if (state is NotifData) {
                              return StreamBuilder(
                                  stream: Stream.periodic(
                                      Duration(minutes: 1), (_) {}),
                                  builder: ((context, snapshot) {
                                    return _reminderWidget(
                                        "${DateTime.now().hour} ${DateTime.now().minute} ${DateTime.now().hour > 12 ? "pm" : "am"}",
                                        "medicine",
                                        "${state.nextTime?.inHours.toString()}:${state.nextTime?.inMinutes.toString()} mins",
                                        "assets/images/pill1.png",
                                        _appColor.purpleColor,
                                        Colors.white);
                                  }));
                            } else {
                              return StreamBuilder(
                                  stream: Stream.periodic(
                                      Duration(minutes: 1), (_) {}),
                                  builder: ((context, snapshot) {
                                    return _reminderWidget(
                                        "${DateTime.now().hour} ${DateTime.now().minute} ${DateTime.now().hour > 12 ? "pm" : "am"}",
                                        "medicine",
                                        "No Data",
                                        "assets/images/pill1.png",
                                        _appColor.purpleColor,
                                        Colors.white);
                                  }));
                            }
                          }),
                      SizedBox(
                        height: 12.0,
                      ),
                      _reminderWidget(
                        "${DateTime.now().hour} ${DateTime.now().minute} ${DateTime.now().hour > 12 ? "pm" : "am"}",
                        "Bactrium",
                        "45 mins",
                        "assets/images/pill2.png",
                        _appColor.pinkColor,
                        Colors.black,
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      _reminderWidget(
                        "${DateTime.now().hour} ${DateTime.now().minute} ${DateTime.now().hour > 12 ? "pm" : "am"}",
                        "Healer",
                        "45 mins",
                        "assets/images/pill3.png",
                        _appColor.lightPurpleColor.withAlpha(90),
                        Colors.black,
                      ),
                    ]),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  _reminderWidget(String time, String type, String remainingTime,
      String imagePath, Color color, Color textColor) {
    return Container(
      height: 150.0,
      width: double.infinity,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  "Next $type in $remainingTime",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  "Take your medicine with water",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withAlpha(80),
                      blurRadius: 200.0,
                      spreadRadius: 0.1,
                      offset: const Offset(
                        0.0,
                        -8.0,
                      ),
                    ),
                  ],
                ),
                child: Image.asset(
                  imagePath,
                  //scale: 0.001,
                  //fit: BoxFit.contain,
                ),
                // child: Center(
                //   child: Icon(
                //     FontAwesomeIcons.pills,
                //     color: Colors.white,
                //     size: 100.0,
                //   ),
                // ),
              ))
        ],
      ),
    );
  }
}
