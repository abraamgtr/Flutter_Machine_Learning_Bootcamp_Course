import 'package:login_firestore_app_section17/domain/entity/Person_entity.dart';

class SignInState {
  SignInState({this.isLogedIn, this.personObject});

  bool? isLogedIn = false;
  PersonEntity? personObject;

  SignInState copyWith({bool? isLogedIn, PersonEntity? personObject}) {
    return SignInState(
        isLogedIn: isLogedIn ?? false, personObject: personObject);
  }
}
