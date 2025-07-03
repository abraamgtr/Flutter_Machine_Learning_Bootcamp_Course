import 'package:contacts_hive_section10/data/Person/Person.dart';
import 'package:contacts_hive_section10/data/Person/Person_mapper.dart';
import 'package:contacts_hive_section10/domain/Person/Person_entity.dart';

abstract class PersonUseCase {
  Future<bool> addContact(Person person);
  Future<List<PersonEntity>> getContacts();
}

class PersonUseCaseImpl extends PersonUseCase {
  PersonMapper _personMapper = PersonMapper();
  @override
  Future<bool> addContact(Person person) async {
    bool successfull = await _personMapper.addContact(person);
    return successfull;
  }

  @override
  Future<List<PersonEntity>> getContacts() async {
    List<PersonEntity> contactsList = await _personMapper.getContacts();
    return contactsList;
  }
}
