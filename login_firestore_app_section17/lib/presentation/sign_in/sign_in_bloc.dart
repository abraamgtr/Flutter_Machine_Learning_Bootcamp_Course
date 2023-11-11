import 'package:bloc/bloc.dart';
import 'package:login_firestore_app_section17/domain/entity/Person_entity.dart';
import 'package:login_firestore_app_section17/domain/usecase/Person_usecase.dart';

import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInState()) {
    on<InitEvent>(_init);
    on<SignUpTriggerEvent>(_signUp);
  }

  void _init(InitEvent event, Emitter<SignInState> emit) async {}

  void _signUp(SignUpTriggerEvent event, Emitter<SignInState> emit) async {
    PersonUsecaseImpl personUsecaseImpl = PersonUsecaseImpl();
    String? personIsAdded =
        await personUsecaseImpl.addUser(personObject: event.personObject);

    PersonEntity? searchingPerson = await personUsecaseImpl.getPerson(
        personObject: PersonEntity(
            email: "test2@email.com", fullName: "test2 user", age: "33"));

    print("searching = ${searchingPerson?.fullName}");

    if (personIsAdded != null && personIsAdded == "Adding User Done!") {
      emit(state.copyWith(isLogedIn: true, personObject: event.personObject));
    } else {
      emit(state.copyWith(isLogedIn: false, personObject: null));
    }
  }
}
