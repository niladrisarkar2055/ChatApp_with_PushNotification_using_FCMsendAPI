import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:listview_in_blocpattern/TokenForMessageBox.dart';
import 'package:listview_in_blocpattern/database_manager.dart';


//This the chatbox of the user and the selected receiver 
class MessageBox extends StatefulWidget {
  @override
  State<MessageBox> createState() => _MessageBoxState();
}


//controller to fetch the mssg inside the textfield 
final TextEditingController msgController = TextEditingController(); 

class _MessageBoxState extends State<MessageBox> {

  //to show the messages in a listview
  List Messages = [];

  @override
  void initState() {
    fetchMessages();
    super.initState();
  }


  //Fectching the messages with the help of fetchMessages() fucntion 
  //to show them in the chatbox timestamp wise 
  fetchMessages() async {
    dynamic result = await DatabaseManager().fetchMessages();
    if (result == null) {
      print('Error in retriving UserData');
    } else {
      setState(() {
        Messages = result;
      });
      print(Messages.length);
      return Messages;
    }
  }

  @override
  Widget build(BuildContext context) {


    //uid of the sender 
    final SenderUID = context.read<User>().uid;

    //the token of the receiver to align the chats 
    //if the token is of receiver's then it should go to the left otherwise right
    final arg =
        ModalRoute.of(context)!.settings.arguments as TokenForMessageBox;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 112, 121, 181),
        title: ListTile(
          title: Text("Receiver"),
          leading:
              CircleAvatar(backgroundImage: AssetImage('assets/avatar1.png')),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              itemCount: Messages.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(

                    //The alignment of the chats if its receiver then go left it not go right 
                    alignment: (Messages[index]['receiver_token'] != arg.token
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),

                        //For colour grading the chats of sender and receiver 
                        color: (Messages[index]['receiver_token'] != arg.token
                            ? Colors.grey.shade200
                            : Colors.blue[200]),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        Messages.length > 0
                            ? Messages[index]['Message']
                            : 'No messages yet',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            ),
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, bottom: 0, top: 10),
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Expanded(

                          //Textfield to send message and send button
                          child: TextField(
                            controller: msgController,
                            decoration: InputDecoration(
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.center,
                                hintText: "Write message...",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          onPressed: () {

                            //sending the messages with :createMessage" function
                            // to the "Chats" collection in firestore to store the chats with their 
                            //timestamp as the uid of the doccuments 
                            int timedata =
                                DateTime.now().millisecondsSinceEpoch;
                            DatabaseManager().createMessage(timedata, SenderUID,
                                arg.token, msgController.text.trim());

                            //Sending push notification to the receiver with the help of 
                            //sendMessage method 
                            DatabaseManager().sendMessage(
                                arg.token,
                                'You got new Message',
                                msgController.text.trim());
                            msgController.clear();
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                          backgroundColor: Colors.blue,
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
