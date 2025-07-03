import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:section16_med_reminder/Utils/AppColor.dart';
import 'package:section16_med_reminder/domain/notification/notification_entity.dart';
import 'package:section16_med_reminder/feature/home/home_bloc.dart';
import 'package:section16_med_reminder/feature/home/home_event.dart';
import 'package:section16_med_reminder/main.dart';

class AddPillScreen extends StatefulWidget {
  AddPillScreen({
    Key? key,
    required HomeBloc homeBloc,
  })  : _homeBloc = homeBloc,
        super(key: key);

  final HomeBloc _homeBloc;

  @override
  State<AddPillScreen> createState() => _AddPillScreenState();
}

class _AddPillScreenState extends State<AddPillScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AppColor _appColor = AppColor();
  List<String> _pillsType = ["Select One", "medicine", "bactrium", "healer"];
  DateTime selectedDate = DateTime.now();
  TextEditingController _pillDateController = TextEditingController();
  String _selectedType = "Select One";

  Future<void> _selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 6)),
    ).then((selectedDate) {
      if (selectedDate != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((selectedTime) {
          if (selectedTime != null) {
            DateTime selectedDateTime = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );

            setState(() {
              _pillDateController.text = selectedDateTime.toIso8601String();
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _pillDateController,
              canRequestFocus: false,
              onTap: () async {
                FocusScopeNode().requestFocus();
                _selectDate(context);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please select a Date";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Select Pill Date",
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: _appColor.lightPurpleColor,
                )),
                suffixIcon: IconButton(
                  icon: Icon(FontAwesomeIcons.calendar),
                  onPressed: () async {
                    await _selectDate(context);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedType,
              borderRadius: BorderRadius.circular(8.0),
              items: _pillsType.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {
                setState(() {
                  _selectedType = _ ?? "";
                });
              },
            ),
            SizedBox(
              height: 12.0,
            ),
            InkWell(
              onTap: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  if (_selectedType == "Select One") {
                    Fluttertoast.showToast(
                        msg: "Please Select a Type for Medicine",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: _appColor.purpleColor,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    widget._homeBloc.add(ScheduleHomeNotifEvent(
                        notificationData: NotificationEntity(
                            pillTime: DateTime.parse(_pillDateController.text),
                            type: _selectedType)));
                    Fluttertoast.showToast(
                        msg: "$_selectedType Notification Scheduled",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: _appColor.purpleColor,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    setState(() {
                      _pillDateController.clear();
                      _selectedType = "Select One";
                      currentIndex = 0;
                      Navigator.of(context).pushNamed("/home");
                    });
                  }
                }
              },
              child: Container(
                height: 60.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _appColor.purpleColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Center(
                  child: Text(
                    "Add Notification",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
