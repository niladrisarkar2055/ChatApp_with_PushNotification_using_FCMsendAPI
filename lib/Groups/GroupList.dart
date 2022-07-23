import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listview_in_blocpattern/auth_service.dart';
import 'package:listview_in_blocpattern/chatList.dart';
import 'package:listview_in_blocpattern/database_manager.dart';
import 'package:listview_in_blocpattern/multiselect.dart';
import 'package:listview_in_blocpattern/userModel.dart';

class GroupList extends StatefulWidget {
  const GroupList({Key? key}) : super(key: key);

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  List<dynamic> Users = [];
  List<dynamic> groups = [];
  List<String> userEmails = [];
  String currUserEmail = '';

  @override
  void initState() {
    fetchuserInfo();
    fetchGroupList();
    super.initState();
  }

  fetchGroupList() async {
    dynamic resultGroups = await DatabaseManager().fetchGroupList();
    if (resultGroups == null) {
      print('Error in retriving UserData');
    } else {
      setState(() {
        groups = resultGroups;
      });
    }
    return groups;
  }

  fetchuserInfo() async {
    dynamic resultUsers = await DatabaseManager().fetchUserList();
    if (resultUsers == null) {
      print('Error in retriving UserData');
    } else {
      setState(() {
        Users = resultUsers;
      });
    }
    for (int i = 0; i < Users.length; i++) {
      if (currUserEmail == Users[i]['Email']) {
        continue;
      } else {
        setState(() {
          userEmails.add(Users[i]['Email']);
        });
      }
    }
    return Users;
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user =
        UserModel(context.read<User>().email!, context.read<User>().uid);
    currUserEmail = user.email;

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(user.email),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey)),
                  onPressed: (() {
                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => MultiSelect(
                                  senderUID: user.email,
                                  userEmails: userEmails,
                                )
                                ));
                  }),
                  child: Text('+ Grp')),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey)),
                  onPressed: (() {
                    context.read<AuthService>().signOut();
                  }),
                  child: Text('Log out'))
            ],
          ),
        ),
        // there is the name of t

        body: SingleChildScrollView(
          
              child:ListView.builder(
                itemCount: groups.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                itemBuilder: (context, index) {
                  return ChatList(
                      imageUrl: 'assets/group.png',
                      date: '10/05',
                      receieverTokens: groups[index]['receiver_token'],
                      // usertoken: user.
                      //ChatroomId
                      chatroomId: groups[index]['group_name'],
                      sender: groups[index]['admin_uID'],
                      receiver: groups[index]['group_name']);
                },
              ),
           
        ));
  }
}

//Forfinding The chatroom Id
getChatRoomId(String a, String b) {
  for (int i = 0; i < min(a.length, b.length); i++) {
    int x = a[i].compareTo(b[i]);
    if (x > 0) {
      return "$b\_$a";
    } else if (x < 0) {
      return "$a\_$b";
    }
  }

}