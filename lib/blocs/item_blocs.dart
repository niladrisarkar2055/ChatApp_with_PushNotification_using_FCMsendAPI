
import 'package:listview_in_blocpattern/blocs/item_events.dart';
import 'package:listview_in_blocpattern/blocs/item_state.dart';
import 'package:listview_in_blocpattern/data/models/Models.dart';
import 'package:listview_in_blocpattern/data/repository/item_repo.dart';
import 'package:bloc/bloc.dart';



class ItemBloc extends Bloc<ItemEvent, ItemState> {
  //Initalizing the ItemRepository as repository for our Bloc
  late ItemRepository repository;
  
  ItemState get initialState => ItemInitialState();
  //Constructor for ItemBloc
  ItemBloc({required this.repository}) : super(ItemInitialState()) {

    //On fuction reads the Event and return the corresponding States using emit
    on<SendMessage>((event, emit) async {
      emit(ItemLoadingState());
      // try {
        ApiResultModel items = await repository.sendMessage(event.token, event.title, event.body, event.chatRoomID, event.senderToken, event.SenderEmail);
        emit(ItemLoadedState(items: items));
      //  } catch (e) {
      //   emit(ItemErrorState(message: e.toString()));
      // }
    });
  }
  
  
}

