import 'dart:async';

import 'package:ChatGo/model/helper.dart';
import 'package:ChatGo/services/exportServices.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final AuthFunctions authFunctions;
  final ChatDatabase chatDatabase;

  SigninBloc({SigninState initialState, this.authFunctions, this.chatDatabase})
      : super(initialState);

  @override
  Stream<SigninState> mapEventToState(
    SigninEvent event,
  ) async* {
    if (event is FetchSignInEvent) {
      yield SignInLoadingState();
      try {
        UserCredential userId;
        userId = await authFunctions.signInWithEmailAndPassword(
            event.email, event.password);
        if (userId != null) {
          SaveData.saveUserLoggedInPreferences(true);
          QuerySnapshot snapshot =
              await chatDatabase.getUserName(email: event.email);
          SaveData.saveUserNameInPreferences(snapshot.docs[0].data()["name"]);
          print(Helper.myName);
          yield SignInLoadedState();
        }
      } catch (error) {
        print(error);
        switch (error.code) {
          case "ERROR_USER_NOT_FOUND":
            SignInErrorState("User with this email doesn't exist.");
            break;
          case "ERROR_USER_DISABLED":
            SignInErrorState("User with this email has been disabled.");
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            SignInErrorState("Too many requests. Try again later.");
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
            SignInErrorState(
                "Signing in with Email and Password is not enabled.");
            break;
          case "ERROR_WRONG_PASSWORD":
            SignInErrorState("Wrong Password");
            break;
          default:
            SignInErrorState("An undefined Error happened.");
        }
      }
    }
  }
}
