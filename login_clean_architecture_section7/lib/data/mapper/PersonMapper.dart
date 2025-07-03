import 'package:login_clean_architecture_section7/data/datasource/PersonDataSource.dart';
import 'package:login_clean_architecture_section7/data/dto/Person.dart';
import 'package:login_clean_architecture_section7/domain/entity/Person_entity.dart';

class PersonMapper {
  PersonMapper();
  PersonDataSource _personDataSource = PersonDataSource();

  PersonEntity getPersonMapper({String? email}) {
    PersonDTO person = _personDataSource.getPersonRemote(email: email);

    PersonEntity _personEntity = PersonEntity.fromJson(person.toJson());

    return _personEntity;
  }
}
