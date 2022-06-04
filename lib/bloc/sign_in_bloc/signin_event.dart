part of 'signin_bloc.dart';

@immutable
abstract class SigninEvent extends Equatable {}

class FetchSignInEvent extends SigninEvent {
  final String email;
  final String password;

  FetchSignInEvent({this.email, this.password});
  @override
  List<Object> get props => [email, password];
}
