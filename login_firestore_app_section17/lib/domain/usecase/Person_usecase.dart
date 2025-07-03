import 'package:login_firestore_app_section17/data/mapper/PersonMapper.dart';
import 'package:login_firestore_app_section17/domain/entity/Person_entity.dart';

abstract class PersonUsecase {
  PersonMapper _personMapper = PersonMapper();
  Future<String?> addUser({PersonEntity? personObject});
  Future<PersonEntity?> getPerson({PersonEntity? personObject});
}

class PersonUsecaseImpl extends PersonUsecase {
  @override
  Future<String?> addUser({PersonEntity? personObject}) async {
    String? personAdded =
        await _personMapper.addPerson(personObject: personObject);

    return personAdded;
  }

  @override
  Future<PersonEntity?> getPerson({PersonEntity? personObject}) async {
    PersonEntity? person =
        await _personMapper.getPerson(personObject: personObject);

    return person;
  }
}
