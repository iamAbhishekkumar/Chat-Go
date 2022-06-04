import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatDatabase {
  addNameToDatabase(userMap) {
    return FirebaseFirestore.instance.collection('users').add(userMap);
  }

  addConversation({String chatRoomId, messageMap}) {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap);
  }

  updateLastMessage({String message, String chatRoomId}) {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .update({
      'lastMessage': message,
      'time': DateFormat.jm().format(DateTime.now()).toString(),
    });
  }

  createChatRoom({String chatRoomId, chatRoomMap}) {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .set(chatRoomMap);
  }

  getUserInfo({String username}) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .get();
  }

  getUserName({String email}) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  getConversation({String chatRoomId}) async {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('time')
        .snapshots();
  }

  getChatRoom({String username}) {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: username)
        .snapshots();
  }
}
