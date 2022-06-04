part of 'signin_bloc.dart';

@immutable
abstract class SigninState extends Equatable {}

class SigninInitial extends SigninState {
  @override
  List<Object> get props => [];
}

class SignInLoadingState extends SigninState {
  @override
  List<Object> get props => [];
}

class SignInLoadedState extends SigninState {
  @override
  List<Object> get props => [];
}

class SignInErrorState extends SigninState {
  final String errorMessage;
  SignInErrorState(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
