import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class DatabaseManager {
  final CollectionReference userList =
      FirebaseFirestore.instance.collection('UserInfo');
  final CollectionReference chats =
      FirebaseFirestore.instance.collection('Chats');

  Future<void> createuser(String email, String uId, String token) async {
    Map<String, String> map = {
      'Email': email,
      'uID': uId,
      'Token': token,
    };
    return await userList.doc(uId).set(map);
    // doc(uId).set({
    //   'Email': email,
    //   'uID': uId,
    //   'Token': token,
    // });
  }

  getUserInfo(String email) async {
    return userList.where("Email", isEqualTo: email).get().catchError((e) {
      print(e.toString());
    });
  }

  Future<void> createMessage(int timestamp, String uId, String receiverToken,
      String message, String chatroomId) async {
    int tdata = DateTime.now().millisecondsSinceEpoch;
    return await chats.doc(chatroomId).collection("chatroom").doc('${timestamp}').set({
      'timestamp': tdata,
      'uID': uId,
      'receiver_token': receiverToken,
      'Message': message,
    });

    // return await chats.doc(chatroomId).collection("chatroom").doc('${timestamp}').set(chatmessageMap).catchError((e){
    //       print(e.toString());
    // });
  }

  Future fetchUserList() async {
    List profileUserList = [];
    try {
      await userList.get().then((value) {
        value.docs.forEach((element) {
          profileUserList.add(element.data());
        });
      });
      return profileUserList;
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchMessages(
      String chatroomId
      ) async {
    List messageList = [];
    try {
      await chats.doc(chatroomId).collection("chatroom").orderBy('timestamp', descending: true).get().then((value) {
        value.docs.forEach((element) {
          messageList.add(element.data());
        });
      });
      return messageList;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool>? addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("Chats")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }
}
