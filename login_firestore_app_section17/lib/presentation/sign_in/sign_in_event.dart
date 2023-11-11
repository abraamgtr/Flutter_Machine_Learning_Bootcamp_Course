import 'package:login_firestore_app_section17/domain/entity/Person_entity.dart';

abstract class SignInEvent {}

class InitEvent extends SignInEvent {}

class SignUpTriggerEvent extends SignInEvent {
  PersonEntity? personObject;
  SignUpTriggerEvent({this.personObject});
}
