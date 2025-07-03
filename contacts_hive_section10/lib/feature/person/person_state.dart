import 'package:contacts_hive_section10/domain/Person/Person_entity.dart';

class PersonState {
  String? message;
  List<PersonEntity>? contactsList;
  PersonState init({String? message}) {
    return PersonState(message: message);
  }

  PersonState loading() {
    return PersonState();
  }

  PersonState? errorState({String? message}) {
    return PersonState().copyWith(message: message ?? "");
  }

  PersonState? contactsDataState({List<PersonEntity>? contacts}) {
    return PersonState().copyWith(contactsList: contacts ?? []);
  }

  PersonState({String? message, List<PersonEntity>? contactsList}) {
    this.message = message;
    this.contactsList = contactsList;
  }

  PersonState? copyWith({String? message, List<PersonEntity>? contactsList}) {
    return PersonState(message: message, contactsList: contactsList);
  }
}
