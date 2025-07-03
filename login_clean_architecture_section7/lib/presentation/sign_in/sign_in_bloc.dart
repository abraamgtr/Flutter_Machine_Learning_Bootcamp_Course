import 'package:bloc/bloc.dart';
import 'package:login_clean_architecture_section7/domain/entity/Person_entity.dart';
import 'package:login_clean_architecture_section7/domain/usecase/Person_usecase.dart';

import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInState()) {
    on<InitEvent>(_init);
    on<SignInTriggerEvent>(_signIn);
  }

  void _init(InitEvent event, Emitter<SignInState> emit) async {}

  void _signIn(SignInTriggerEvent event, Emitter<SignInState> emit) async {
    PersonUsecaseImpl personUsecaseImpl = PersonUsecaseImpl();
    PersonEntity person = personUsecaseImpl.getPersonEntity(email: event.email);

    emit(state.copyWith(isLogedIn: true, email: person.email));
  }
}
