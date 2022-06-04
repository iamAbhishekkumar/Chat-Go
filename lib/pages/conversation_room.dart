import 'package:ChatGo/bloc/conversation/conversation_bloc.dart';
import 'package:ChatGo/model/helper.dart';
import 'package:ChatGo/model/mycolors.dart';
import 'package:ChatGo/widgets/error_occured.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationRoom extends StatefulWidget {
  final bool isNameSearched;

  const ConversationRoom({Key key, this.isNameSearched}) : super(key: key);
  @override
  _ConversationRoomState createState() => _ConversationRoomState();
}

class _ConversationRoomState extends State<ConversationRoom> {
  TextEditingController _messageController = TextEditingController();
  ConversationBloc _conversationBloc;
  ScrollController _scrollcontroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConversationBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            appbar(context),
            Expanded(
              child: blocController(),
            ),
            messageBox(context),
          ],
        ),
      ),
    );
  }

  Widget blocController() {
    return BlocBuilder<ConversationBloc, ConversationState>(
      builder: (context, state) {
        if (state is ConversationInitial) {
          _conversationBloc = BlocProvider.of<ConversationBloc>(context);
          if (widget.isNameSearched)
            _conversationBloc.add(CreatePersonalChatRoom());
          _conversationBloc.add(FetchMessages());
        } else if (state is MessagesLoadedState) {
          return messagesList(chatMessageStream: state.chatMessageStream);
        } else if (state is ErrorState) {
          return ErrorOccured(error: state.errorMessage);
        } else if (state is SendMessageLoadedState) {
          _conversationBloc.add(FetchMessages());
          _scrollcontroller.animateTo(
            _scrollcontroller.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 500),
          );
        }
        return Container();
      },
    );
  }

  Widget appbar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          )
        ],
      ),
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 25,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.07),
                Text(
                  Helper.otherPersonName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: "gilroy",
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget messageBox(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: TextField(
                controller: _messageController,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  border: InputBorder.none,
                  hintText: "Message...",
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: "gilroy",
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300], width: 2),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          SizedBox(width: 5),
          FloatingActionButton(
            onPressed: () {
              _conversationBloc
                  .add(SendMessages(message: _messageController.text));
              _messageController.clear();
              _scrollcontroller.animateTo(
                _scrollcontroller.position.maxScrollExtent,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 500),
              );
            },
            child: Icon(Icons.send),
            backgroundColor: MyColor.green,
          )
        ],
      ),
    );
  }

  Widget messagesList({Stream chatMessageStream}) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: _scrollcontroller,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return messageTile(
                      context,
                      snapshot.data.documents[index].data()['message'],
                      snapshot.data.documents[index].data()['sendBy'],
                    );
                  },
                )
              : Container();
        },
      ),
    );
  }

  Widget messageTile(BuildContext context, String message, String sendBy) {
    bool isThisMe = sendBy == Helper.myName;
    Radius _radius = Radius.circular(30);
    return Container(
      alignment: isThisMe ? Alignment.centerRight : Alignment.bottomLeft,
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(children: [
            Text(
              "$sendBy : ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: "gilroy",
              ),
            ),
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: "gilroy",
              ),
            ),
          ]),
          decoration: BoxDecoration(
            color: isThisMe ? MyColor.purple : MyColor.blue,
            borderRadius: isThisMe
                ? BorderRadius.only(
                    topLeft: _radius,
                    topRight: _radius,
                    bottomLeft: _radius,
                    bottomRight: Radius.circular(5))
                : BorderRadius.only(
                    topLeft: _radius,
                    topRight: _radius,
                    bottomRight: _radius,
                    bottomLeft: Radius.circular(5)),
          ),
        ),
      ),
    );
  }
}
