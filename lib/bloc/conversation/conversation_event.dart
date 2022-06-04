part of 'conversation_bloc.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();
  @override
  List<Object> get props => [];
}

class CreatePersonalChatRoom extends ConversationEvent {
  CreatePersonalChatRoom();
}

class FetchMessages extends ConversationEvent {}

class SendMessages extends ConversationEvent {
  final String message;
  SendMessages({this.message});
}
