abstract class ValidateEvent {}

class InitEvent extends ValidateEvent {}

class CheckForValidationEvent extends ValidateEvent {
  CheckForValidationEvent({required this.email});

  String email;
}
