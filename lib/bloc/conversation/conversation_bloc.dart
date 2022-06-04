import 'dart:async';

import 'package:ChatGo/model/helper.dart';
import 'package:ChatGo/services/exportServices.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ChatDatabase _chatDatabase = ChatDatabase();
  ConversationBloc() : super(ConversationInitial());

  @override
  Stream<ConversationState> mapEventToState(
    ConversationEvent event,
  ) async* {
    if (event is FetchMessages) {
      try {
        var stream =
            await _chatDatabase.getConversation(chatRoomId: Helper.chatRoomId);
        yield MessagesLoadedState(chatMessageStream: stream);
      } catch (e) {
        print(e);
        yield ErrorState(e.toString());
      }
    }

    if (event is SendMessages) {
      try {
        Map<String, dynamic> messageMap = {
          'message': event.message,
          'sendBy': Helper.myName,
          'time': DateTime.now().millisecondsSinceEpoch,
        };
        _chatDatabase.addConversation(
            chatRoomId: Helper.chatRoomId, messageMap: messageMap);
        if (event.message.length != 0)
          _chatDatabase.updateLastMessage(
              chatRoomId: Helper.chatRoomId, message: event.message);
        yield SendMessageLoadedState();
      } catch (e) {
        print(e);
        yield ErrorState(e.toString());
      }
    }

    if (event is CreatePersonalChatRoom) {
      try {
        yield LoadingState();

        String chatRoomId =
            getChatRoomId(Helper.otherPersonName, Helper.myName);
        Helper.chatRoomId = chatRoomId;
        List<String> users = [Helper.otherPersonName, Helper.myName];

        Map<String, dynamic> chatRoomMap = {
          'users': users,
          'chatRoomId': chatRoomId,
          'lastMessage': "",
          'time': "",
        };
        _chatDatabase.createChatRoom(
            chatRoomId: chatRoomId, chatRoomMap: chatRoomMap);
        yield CreatePersonalChatRoomLoadedState();
      } catch (e) {
        print(e);
        yield ErrorState("Unidentified error happen");
      }
    }
  }

  String getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }
}
