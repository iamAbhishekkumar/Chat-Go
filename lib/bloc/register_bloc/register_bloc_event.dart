part of 'register_bloc_bloc.dart';

abstract class RegisterEvent extends Equatable {}

class FetchRegisterEvent extends RegisterEvent {
  final String email;
  final String password;
  final String username;

  FetchRegisterEvent({this.email, this.password, this.username});
  @override
  List<Object> get props => [email, password, username];
}
