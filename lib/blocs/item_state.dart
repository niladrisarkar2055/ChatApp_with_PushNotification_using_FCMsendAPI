
import 'package:equatable/equatable.dart';
import 'package:listview_in_blocpattern/data/models/Models.dart';



//Declearing all the states of our feature
abstract class ItemState extends Equatable {}

//There should be only one InitialState for a feature 
//For every API, there should be three states, LoadingState, LoadedState, ErrorState.

class ItemInitialState extends ItemState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ItemLoadedState extends ItemState {
  ApiResultModel items;
  ItemLoadedState({required this.items});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ItemLoadingState extends ItemState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ItemErrorState extends ItemState {
  String message;
  ItemErrorState({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}