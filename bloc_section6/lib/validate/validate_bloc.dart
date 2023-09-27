import 'package:bloc/bloc.dart';

import 'validate_event.dart';
import 'validate_state.dart';

class ValidateBloc extends Bloc<ValidateEvent, ValidateState> {
  ValidateBloc() : super(ValidateState()) {
    on<InitEvent>(_init);
    on<CheckForValidationEvent>(_checkForValidation);
  }

  void _init(InitEvent event, Emitter<ValidateState> emit) async {}

  void _checkForValidation(
      CheckForValidationEvent event, Emitter<ValidateState?> emit) {
    if (event.email.contains("@")) {
      emit(state.copyWith(
          isValid: true,
          validationMessage: "Entered email address is correct!"));
    } else {
      emit(state.copyWith(
          isValid: false,
          validationMessage: "Entered email address is wrong!"));
    }
  }
}
