import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:listview_in_blocpattern/chatCardModel.dart';
import 'package:http/http.dart' as http;
import 'package:listview_in_blocpattern/fcmMessage.dart';

//This is Databasemanager class 

class DatabaseManager {
  //UserInfo collection to store user information
  final CollectionReference userList =
      FirebaseFirestore.instance.collection('UserInfo');

    //Chats collection to store chats of user 
  final CollectionReference chats =
      FirebaseFirestore.instance.collection('Chats');


  //Creates a user in UserInfo with its email,uid and token 
  Future<void> createuser(String email, String uId, String token) async {
    return await userList.doc(uId).set({
      'Email': email,
      'uID': uId,
      'Token': token,
    });
  }
  
  //Creates a message send by a user and stores in Chat with timestamp uid and field timestamp, uid , 
  //token of the receiver and the data inside the message 
  Future<void> createMessage(
      int timestamp, String uId, String receiverToken, String message) async {
    int tdata = DateTime.now().millisecondsSinceEpoch;
    return await chats.doc('${timestamp}').set({
      'timestamp': tdata,
      'uID': uId,
      'receiver_token': receiverToken,
      'Message': message,
    });
  }

  //This function is basically for fetching the users list from the firebase 
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

  //This function is for fecthing messages by timestamp from the data and showing them in our chat box just like Whatsapp 
  //The messages are fetched by their time stamp so that earliest message is on the top and last message at the bottom 
  Future fetchMessages() async {
    List messageList = [];
    try {
      await chats.orderBy('timestamp').get().then((value) {
        value.docs.forEach((element) {
          messageList.add(element.data());
        });
      });
      return messageList;
    } catch (e) {
      print(e.toString());
    }
  }

  //This is for sending push notification with FCM api 
  //Here We are hitting the api with our message that needs to be sent as notification 
  //and sending it to the receiver's device 
  Future<http.Response> sendMessage(
      String token, String title, String body) async {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'key=AAAAfIAwgFg:APA91bHs-PUH5lXteAK03p-srZHZWSuLOVVouhJXGv1Qv4NE-ySaEufvoyX2uhPCbM9rmr2mQVHQJ0XEYQ3CswwtCw0Jw-w81RVsBeoWUJ838t5fXke3F0P-j_NLYm4m8du9-ZOypYFb'
      },
      body: jsonEncode(<String, dynamic>{
        'to': token,
        "content_available": true,
        "notification": {
          "title": title,
          "body": body,
          "click_action": "fcm.ACTION.HELLO"
        },
        "data": {"extra": "Juice"}
      }),
    );

    return response;
  }
}
