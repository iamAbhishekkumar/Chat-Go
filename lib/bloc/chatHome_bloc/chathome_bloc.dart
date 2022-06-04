import 'dart:async';

import 'package:ChatGo/model/helper.dart';
import 'package:ChatGo/services/exportServices.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'chathome_event.dart';
part 'chathome_state.dart';

class ChatHomeBloc extends Bloc<ChatHomeEvent, ChatHomeState> {
  ChatDatabase _chatDatabase = ChatDatabase();
  ChatHomeBloc() : super(ChatHomeInitial());

  @override
  Stream<ChatHomeState> mapEventToState(
    ChatHomeEvent event,
  ) async* {
    if (event is FetchRecentChats) {
      yield ChatHomeLoadingState();
      try {
        await getUserInfo();
        Stream<QuerySnapshot> stream =
            await _chatDatabase.getChatRoom(username: Helper.myName);

        yield ChatHomeLoadedState(stream: stream);
      } catch (e) {
        print(e);
        yield ChatHomeErrorState("Error");
      }
    }
  }

  getUserInfo() async {
    String name = await SaveData.getUserNameInPreferences();
    Helper.myName = name;
  }
}
