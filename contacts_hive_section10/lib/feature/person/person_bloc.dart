import 'package:bloc/bloc.dart';
import 'package:contacts_hive_section10/data/Person/Person.dart';
import 'package:contacts_hive_section10/domain/Person/Person_entity.dart';
import 'package:contacts_hive_section10/domain/Person/Person_usecase.dart';

import 'person_event.dart';
import 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  PersonBloc() : super(PersonState()) {
    on<InitEvent>(_init);
    on<LoadingEvent>(_loading);
    on<ReadContactsEvent>(_read);
    on<AddContactEvent>(_addContact);
  }
  PersonUseCaseImpl _personUsecase = PersonUseCaseImpl();

  void _init(InitEvent event, Emitter<PersonState?> emit) async {
    PersonUseCaseImpl _personUsecase = PersonUseCaseImpl();

    emit(state.loading());
    List<PersonEntity> contactsList = await _personUsecase.getContacts();
    if (contactsList.isEmpty) {
      emit(
          state.copyWith(contactsList: null, message: "There is no contacts!"));
    } else {
      emit(state.copyWith(contactsList: contactsList, message: null));
    }
  }

  void _loading(LoadingEvent event, Emitter<PersonState> emit) async {
    emit(state.loading());
  }

  void _addContact(AddContactEvent event, Emitter<PersonState?> emit) async {
    PersonUseCaseImpl _personUsecase = PersonUseCaseImpl();

    emit(state.loading());
    bool contactAdded = await _personUsecase
        .addContact(event.person ?? Person(name: "test", nickName: "test"));
    if (!contactAdded) {
      emit(state.copyWith(message: "Error Adding Contact"));
    } else {
      List<PersonEntity> contactsList = await _personUsecase.getContacts();

      if (contactsList.isEmpty) {
        emit(state.copyWith(message: "There is no contacts!"));
      } else {
        emit(state.copyWith(contactsList: contactsList));
      }
    }
  }

  void _read(ReadContactsEvent event, Emitter<PersonState?> emit) async {
    emit(state.loading());
    List<PersonEntity> contactsList = await _personUsecase.getContacts();

    if (contactsList.isEmpty) {
      emit(state.copyWith(message: "There is no contacts!"));
    } else {
      emit(state.copyWith(contactsList: contactsList));
    }
  }
}
