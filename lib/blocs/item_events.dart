import 'package:equatable/equatable.dart';


//Here are all the Events related to the feature
abstract class ItemEvent extends Equatable {}

//FetchItemEvent is an event which will fetch the data from API.
class SendMessage extends ItemEvent {
  late String token, title, body;
  SendMessage({required this.token, required this.title, required this.body});
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
