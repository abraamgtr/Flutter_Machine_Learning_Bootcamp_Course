import 'package:contacts_hive_section10/data/Person/Person.dart';

abstract class PersonEvent {}

class InitEvent extends PersonEvent {}

class LoadingEvent extends PersonEvent {}

class AddContactEvent extends PersonEvent {
  Person? person;
  AddContactEvent({this.person});
}

class ReadContactsEvent extends PersonEvent {}
