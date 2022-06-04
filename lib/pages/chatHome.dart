import 'package:ChatGo/bloc/chatHome_bloc/chathome_bloc.dart';
import 'package:ChatGo/model/helper.dart';
import 'package:ChatGo/pages/conversation_room.dart';
import 'package:ChatGo/widgets/error_occured.dart';
import 'package:ChatGo/widgets/loading.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatHome extends StatefulWidget {
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  Stream chatHomeStream;
  ChatHomeBloc _chatHomeBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ChatHomeBloc(),
        child: Column(
          children: <Widget>[
            topText(),
            Expanded(child: blocController()),
          ],
        ));
  }

  Widget blocController() {
    return BlocBuilder<ChatHomeBloc, ChatHomeState>(
      builder: (context, state) {
        if (state is ChatHomeInitial) {
          _chatHomeBloc = BlocProvider.of<ChatHomeBloc>(context);
          _chatHomeBloc.add(FetchRecentChats());
        } else if (state is ChatHomeLoadingState) {
          return Loading();
        } else if (state is ChatHomeLoadedState) {
          return recentChats(state.stream);
        } else if (state is ChatHomeErrorState) {
          return ErrorOccured(error: state.errorMessage);
        }
        return Container();
      },
    );
  }

  Widget topText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Text(
            "Messages",
            style: TextStyle(
              color: Colors.black,
              fontSize: 35,
              fontFamily: "gilroy_bold",
            ),
          ),
        ),
      ],
    );
  }

  Widget recentChats(Stream recentChats) {
    return StreamBuilder(
      stream: recentChats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                    ),
                    onTap: () {
                      navigateToPersonalChat(
                          context: context,
                          chatRoomId: snapshot.data.documents[index]
                              .data()['chatRoomId'],
                          otherPersonName: snapshot.data.documents[index]
                              .data()['chatRoomId']
                              .replaceAll("_", "")
                              .replaceAll(Helper.myName, ""));
                    },
                    title: Text(
                      snapshot.data.documents[index]
                          .data()['chatRoomId']
                          .replaceAll("_", "")
                          .replaceAll(Helper.myName, ""),
                      style: TextStyle(fontFamily: "gilroy", fontSize: 22),
                    ),
                    subtitle: Text(
                      snapshot.data.documents[index].data()['lastMessage'],
                      style: TextStyle(fontFamily: "gilroy", fontSize: 18),
                    ),
                    trailing: Text(
                      snapshot.data.documents[index].data()['time'],
                      style: TextStyle(fontFamily: "gilroy", fontSize: 15),
                    ),
                  );
                },
              )
            : Container();
      },
    );
  }
}

void navigateToPersonalChat({
  String chatRoomId,
  String otherPersonName,
  BuildContext context,
}) {
  Helper.chatRoomId = chatRoomId;
  Helper.otherPersonName = otherPersonName;
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationRoom(
          isNameSearched: false,
        ),
      ));
}
