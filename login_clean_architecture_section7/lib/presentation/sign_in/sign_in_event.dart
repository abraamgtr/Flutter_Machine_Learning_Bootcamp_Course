abstract class SignInEvent {}

class InitEvent extends SignInEvent {}

class SignInTriggerEvent extends SignInEvent {
  String? email;
  SignInTriggerEvent({this.email});
}
