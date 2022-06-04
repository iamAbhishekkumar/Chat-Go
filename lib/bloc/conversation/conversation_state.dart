part of 'conversation_bloc.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationInitial extends ConversationState {}

class LoadingState extends ConversationState {}

class ErrorState extends ConversationState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}

class CreatePersonalChatRoomLoadedState extends ConversationState {}

class MessagesLoadedState extends ConversationState {
  final Stream chatMessageStream;
  MessagesLoadedState({this.chatMessageStream});
}

class SendMessageLoadedState extends ConversationState {}

// class CreateGroupChatRoomLoadingState extends ChatsState {
//   @override
//   List<Object> get props => [];
// }

// class CreateGroupChatRoomLoadedState extends ChatsState {
//   @override
//   List<Object> get props => [];
// }

// class CreateGroupChatRoomErrorState extends ChatsState {
//   final String errorMessage;

//   CreateGroupChatRoomErrorState({this.errorMessage});
//   @override
//   List<Object> get props => [errorMessage];
//
