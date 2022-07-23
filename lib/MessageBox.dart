import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:listview_in_blocpattern/blocs/item_state.dart';
import 'package:listview_in_blocpattern/data/models/Models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listview_in_blocpattern/database_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'blocs/item_blocs.dart';
import 'blocs/item_events.dart';

class MessageBox extends StatefulWidget {
  List token;
  String chatroomID; //ChatroomId
  String receiver;
  dynamic senderToken;

  MessageBox(
      {Key? key,
      required this.token,
      required this.chatroomID,
      required this.receiver})
      : super(key: key);

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

final TextEditingController msgController = TextEditingController();

class _MessageBoxState extends State<MessageBox> {
  List Messages = [];
  late ItemBloc itemBloc;
  List<Results> fooditems = [];

  dynamic senderToken;

  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((value){
      setState(() {
        senderToken = value;
      });
    },);
    fetchMessages(widget.chatroomID);
    super.initState();
    itemBloc = BlocProvider.of<ItemBloc>(context);
  }

  fetchMessages(String chatroomID) async {
    dynamic result = await DatabaseManager().fetchMessages(chatroomID);
    if (result == null) {
      print('Error in retriving UserData');
    } else {
      setState(() {
        Messages = result;
      });
      return Messages;
    }
 
  }

  _sendMessageArea(dynamic SenderUID, dynamic senderEmail, List token,
      String chatroomID) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: 70,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: msgController,
                decoration: const InputDecoration.collapsed(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            FloatingActionButton(
              onPressed: () {
                int timedata = DateTime.now().millisecondsSinceEpoch;
                DatabaseManager().createMessage(timedata, SenderUID, token,
                    msgController.text.trim(), chatroomID, senderEmail);
                

              

                // for (int i = 0; i < resultsForSenderToken.length; i++) {
                //   if (senderEmail == resultsForSenderToken[i]['Email']) {
                //     senderToken = resultsForSenderToken[i]['Token'];
                    
                //   }
                // }
          
                //We are adding FetchItemEvent in our ItemBloc

                itemBloc.add(SendMessage(
                    token: widget.token,
                    title: senderEmail,
                    body: msgController.text.trim(),
                    chatRoomID: widget.chatroomID,
                    senderToken: senderToken,
                    SenderEmail: senderEmail));

                msgController.clear();
                fetchMessages(widget.chatroomID);
              },
              backgroundColor: Colors.blue,
              elevation: 0,
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final SenderUID = context.read<User>().uid;
    final senderEmail = context.read<User>().email;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 112, 121, 181),
          title: ListTile(
            title: Text(widget.receiver),
            leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/chat.png')),
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: BlocListener<ItemBloc, ItemState>(
          listener: (context, state) => {
            if (state is ItemErrorState) {Text("Something went wrong :(")}
          },
          child: BlocBuilder<ItemBloc, ItemState>(
            builder: (context, state) {
              if (state is ItemErrorState) {
                final error = state.message;
                String ErrorMessage = "${error}\n Try again.";

                return Text(ErrorMessage);
              }
              if (state is ItemLoadingState) {
                return Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                        ),
                        const CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                          color: Colors.purple,
                          strokeWidth: 5,
                        ),
                      ]),
                );
              }
              if (state is ItemLoadedState) {
                fooditems = state.items.results!;
                Fluttertoast.showToast(
                    msg: "Message sent!", // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.CENTER, // location
                    timeInSecForIosWeb: 1 // duration
                    );
                print('You send a message to user!');
              }
              return Column(children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: Messages.length,
                    shrinkWrap: true,
                    reverse: true,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment: (Messages[index]['uID'] != SenderUID
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (Messages[index]['uID'] != SenderUID
                                  ? Colors.grey.shade200
                                  : Colors.blue[200]),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(children: [
                              Text(
                                Messages[index]['senderEmail'],
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                Messages[index]['Message'],
                                style: const TextStyle(fontSize: 15),
                              ),
                            ]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _sendMessageArea(SenderUID, senderEmail, widget.token,
                    widget.chatroomID),
              ]);
              ;
            },
          ),
        ));
  }
}

//   @override
//   Widget build(BuildContext context) {
//     final SenderUID = context.read<User?>()!.uid;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 112, 121, 181),
//         title: ListTile(
//           title: Text(widget.receiver),
//           leading:
//               CircleAvatar(backgroundImage: AssetImage('assets/avatar1.png')),
//         ),
//       ),
//       resizeToAvoidBottomInset: true,
//       body: Column(children: <Widget>[
//         Expanded(
//           child: ListView.builder(
//             itemCount: Messages.length,
//             shrinkWrap: true,
//             reverse: true,
//             padding: const EdgeInsets.only(top: 10, bottom: 10),
//             // physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               return Container(
//                 padding: const EdgeInsets.only(
//                     left: 14, right: 14, top: 10, bottom: 10),
//                 child: Align(
//                   alignment: (Messages[index]['uID'] != SenderUID
//                       ? Alignment.topLeft
//                       : Alignment.topRight),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: (
//                         Messages[index]['uID'] != SenderUID
//                           ? Colors.grey.shade200
//                           : Colors.blue[200]),
//                     ),
//                     padding: EdgeInsets.all(16),
//                     child: Text(
//                       Messages.length > 0
//                           ? Messages[index]['Message']
//                           : 'No messages yet',
//                       style: TextStyle(fontSize: 15),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         _sendMessageArea(SenderUID, widget.token, widget.chatroomID),
//       ]),
//     );
//   }
// }