import 'package:login_firestore_app_section17/data/datasource/PersonDataSource.dart';
import 'package:login_firestore_app_section17/data/dto/Person.dart';
import 'package:login_firestore_app_section17/domain/entity/Person_entity.dart';

class PersonMapper {
  PersonMapper();
  PersonDataSource _personDataSource = PersonDataSource();

  Future<String?> addPerson({required PersonEntity? personObject}) async {
    String? addingUserMessage = await _personDataSource.addUser(
        personObject: PersonDTO.fromJson(personObject?.toJson()));

    return addingUserMessage;
  }

  Future<PersonEntity?> getPerson({required PersonEntity? personObject}) async {
    PersonDTO? personDTO = await _personDataSource.getPerson(
        personObject: PersonDTO.fromJson(personObject?.toJson()));

    PersonEntity? personEntity = PersonEntity.fromJson(personDTO?.toJson());

    return personEntity;
  }
}
