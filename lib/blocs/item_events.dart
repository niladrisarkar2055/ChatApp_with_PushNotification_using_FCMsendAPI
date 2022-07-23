import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ItemEvent extends Equatable {}

//FetchItemEvent is an event which will fetch the data from API.
class SendMessage extends ItemEvent {
  late String title, body, chatRoomID;
  String SenderEmail;
  List token;
  dynamic senderToken;
  SendMessage(
      {required this.token,
      required this.title,
      required this.body,
      required this.chatRoomID,
      required this.senderToken,
      required this.SenderEmail});
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}