import 'dart:async';
import 'package:ChatGo/services/exportServices.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'register_bloc_event.dart';
part 'register_bloc_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthFunctions authFunctions;
  final ChatDatabase chatDatabase;

  RegisterBloc(
      {RegisterState initialState, this.authFunctions, this.chatDatabase})
      : super(initialState);

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is FetchRegisterEvent) {
      yield RegisterLoadingState();
      try {
        UserCredential userId;
        userId = await authFunctions.registerWithEmailAndPassword(
            event.email, event.password);
        if (userId != null) {
          SaveData.saveUserLoggedInPreferences(true);
          SaveData.saveUserNameInPreferences(event.username);

          Map<String, String> userMap = {
            'searchKey': event.username.substring(0, 1),
            'name': event.username,
            'email': event.email,
          };
          await chatDatabase.addNameToDatabase(userMap);
          yield RegisterLoadedState();
        }
      } catch (error) {
        print(error.toString());
        switch (error.code) {
          case 'ERROR_EMAIL_ALREADY_IN_USE':
            yield RegisterErrorState("This email is already registered");
            break;
        }
      }
    }
  }
}
