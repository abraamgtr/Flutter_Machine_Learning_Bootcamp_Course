import 'package:contacts_hive_section10/data/Person/Person.dart';
import 'package:hive/hive.dart';

abstract class PersonLocalDataSource {
  Future<bool> addContact(Person person);
  Future<List<Person>> getContacts();
}

class PersonDataSource extends PersonLocalDataSource {
  PersonDataSource();

  @override
  Future<bool> addContact(Person person) async {
    try {
      var personBox = await Hive.openBox('personBox');
      await personBox.add(person);
      return true;
    } catch (e) {
      print("INFO:=> Error ${e.toString()}");
      return false;
    }
  }

  @override
  Future<List<Person>> getContacts() async {
    try {
      var personBox = await Hive.openBox('personBox');
      print(personBox.toMap());
      List<Person> contactsList = [];
      personBox.toMap().forEach((key, value) {
        contactsList.add(value);
      });
      return contactsList;
    } catch (e) {
      print("INFO:=> Error ${e.toString()}");
      return [];
    }
  }
}
