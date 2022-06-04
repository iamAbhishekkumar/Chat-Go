part of 'chathome_bloc.dart';

abstract class ChatHomeEvent extends Equatable {
  const ChatHomeEvent();

  @override
  List<Object> get props => [];
}

class FetchRecentChats extends ChatHomeEvent {
  @override
  List<Object> get props => [];
}
