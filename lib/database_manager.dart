import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseManager {
  final CollectionReference userList =
      FirebaseFirestore.instance.collection('UserInfo');
  final CollectionReference chats =
      FirebaseFirestore.instance.collection('Chats');
  final CollectionReference groups =
      FirebaseFirestore.instance.collection('Groups');

  Future<void> createuser(String email, String uId, List<String> token) async {
    Map<String, dynamic> map = {
      'Email': email,
      'uID': uId,
      'Token': token,
    };
     await userList.doc(uId).set(map);
  }

  getUserInfo(String email) async {
    return userList.where("Email", isEqualTo: email).get().catchError((e) {
      print(e.toString());
    });
  }

  Future<void> createMessage(int timestamp, String uId, List receiverToken,
      String message, String chatroomId, dynamic senderEmail) async {
    int tdata = DateTime.now().millisecondsSinceEpoch;
    return await chats
        .doc(chatroomId)
        .collection("chatroom")
        .doc('${timestamp}')
        .set({
      'timestamp': tdata,
      'uID': uId,
      'receiver_token': receiverToken,
      'Message': message,
      'senderEmail': senderEmail
    });
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

  Future fetchGroupList() async {
    List groupList = [];
    try {
      await groups.get().then((value) {
        value.docs.forEach((element) {
          groupList.add(element.data());
        });
      });
      return groupList;
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchMessages(String chatroomId) async {
    List messageList = [];
    try {
      await chats
          .doc(chatroomId)
          .collection("chatroom")
          .orderBy('timestamp', descending: true)
          .get()
          .then((value) {
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
    return null;
  }

  Future<void> createGroup(String groupName, String senderUId,
      List<String> receiverEmails, List<String> receiverToken) async {
    return await groups.doc(groupName).set({
      'group_name': groupName,
      'admin_uID': senderUId,
      'receiver_emails': receiverEmails,
      'receiver_token': receiverToken
    });
  }
}