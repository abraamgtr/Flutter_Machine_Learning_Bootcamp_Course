import 'package:contacts_hive_section10/data/Person/Person.dart';
import 'package:contacts_hive_section10/data/Person/Person_datasource.dart';
import 'package:contacts_hive_section10/domain/Person/Person_entity.dart';

abstract class PersonMapperBluePrint {
  Future<bool> addContact(Person person);
  Future<List<PersonEntity>> getContacts();
}

class PersonMapper extends PersonMapperBluePrint {
  PersonDataSource _personDataSource = PersonDataSource();
  PersonMapper();
  @override
  Future<bool> addContact(Person person) async {
    bool successfull = await this._personDataSource.addContact(person);

    return successfull;
  }

  @override
  Future<List<PersonEntity>> getContacts() async {
    List<Person> contactsList = await this._personDataSource.getContacts();
    List<PersonEntity> contactsEntityList = [];

    if (contactsList.isNotEmpty) {
      contactsList.forEach((contact) {
        contactsEntityList.add(PersonEntity.fromJson(contact.toJson()));
      });
      return contactsEntityList;
    } else {
      return [];
    }
  }
}
