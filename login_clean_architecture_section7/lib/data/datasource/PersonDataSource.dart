import 'package:login_clean_architecture_section7/data/dto/Person.dart';

abstract class PersonDataSourceBluePrint {
  PersonDTO getPersonRemote({String? email});
}

class PersonDataSource extends PersonDataSourceBluePrint {
  PersonDataSource();

  @override
  PersonDTO getPersonRemote({String? email}) {
    return PersonDTO.fromJson({"email": email ?? ""});
  }
}
