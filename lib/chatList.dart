import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listview_in_blocpattern/MessageBox.dart';
import 'package:listview_in_blocpattern/database_manager.dart';
import 'package:listview_in_blocpattern/userModel.dart';

import 'blocs/item_blocs.dart';
import 'data/repository/item_repo.dart';

class ChatList extends StatefulWidget {
 
  String token;
  String imageUrl;
  String date;
  String chatroomId;
  String sender;
  String receiver;

  ChatList(
      {
      required this.imageUrl,
      required this.date,
      required this.token,
      required this.chatroomId,
      required this.sender,
      required this.receiver});
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  //for fetching database manager methods
  DatabaseManager databaseManager = new DatabaseManager();

  //onclick a chatroom is created and user is taken to the messagebox is inside
  message(String sender, String receiver, String chatroomId) {
    List<String> users = [sender, receiver];

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatroomId,
    };

    databaseManager.addChatRoom(chatRoom, chatroomId);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => ItemBloc(repository: ItemRepositoryImpl()),
                child: MessageBox(
                  //this token is users token
                    token: widget.token, chatroomID: widget.chatroomId, receiver:widget.receiver))));
  }

  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //   onTap: () {
    //     Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => BlocProvider(
    //                   create: (context) => ItemBloc(
    //                       repository:
    //                           ItemRepositoryImpl()),
    //                   child: MessageBox(token:  widget.token,chatRoomId: chatRoomId))));

    // },

    return GestureDetector(
      onTap: (){
         message(widget.sender, widget.receiver, widget.chatroomId);
      },
      child: Container(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage(widget.imageUrl),
                      maxRadius: 30,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.receiver,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    
              //data
              // Text(
              //   widget.date,
              //   style:
              //       const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              // ),
    
              //new
              // FloatingActionButton(
              //     onPressed: () {
              //       message(widget.sender, widget.receiver, widget.chatroomId);
              //     },
              //     child: Icon(Icons.message))
            ],
          ),
        ),
      ),
    );
  }
}
