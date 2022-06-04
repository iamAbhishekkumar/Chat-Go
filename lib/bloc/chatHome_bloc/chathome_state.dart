part of 'chathome_bloc.dart';

abstract class ChatHomeState extends Equatable {
  const ChatHomeState();

  @override
  List<Object> get props => [];
}

class ChatHomeInitial extends ChatHomeState {}

class ChatHomeLoadingState extends ChatHomeState {}

class ChatHomeLoadedState extends ChatHomeState {
  final Stream stream;

  ChatHomeLoadedState({this.stream});
}

class ChatHomeErrorState extends ChatHomeState {
  final String errorMessage;
  ChatHomeErrorState(this.errorMessage);
}
