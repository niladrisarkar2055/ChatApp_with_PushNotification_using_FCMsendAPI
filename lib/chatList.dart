import 'package:flutter/material.dart';
import 'package:listview_in_blocpattern/MessageBox.dart';
import 'package:listview_in_blocpattern/TokenForMessageBox.dart';


//Chatlist class for 
class ChatList extends StatefulWidget {
  String email;
  String token;
  String imageUrl;
  String date;
 //Constructor 
  ChatList(
      {required this.email,
      required this.imageUrl,
      required this.date,
      required this.token});
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

 

  //basic UI 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/messagebox', arguments: TokenForMessageBox(token: widget.token));
        //gesture detector to go the messagebox of the clicked user .
        
      },
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
                            widget.email,
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
            Text(
              widget.date,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}

