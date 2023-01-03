import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/my_recent_search/my_recent_search.dart';
import 'package:logger/logger.dart';
part 'my_recent_search_event.dart';
part 'my_recent_search_state.dart';

class MyRecentSearchBloc extends Bloc<MyRecentSearchEvent, MyRecentSearchState> {
  MyRecentSearchBloc() : super(const MyRecentSearchLoading()){
    on<GetMyRecentSearch>(_getMyRecentSearch);
    on<LoadMyRecentSearch>(_loadMyRecentSearch);
    on<DeleteMyRecentSearch>(_deleteMyRecentSearch);
  }
  List<MyRecentSearch> myRecentList = [];
  int index = 0;
  var logger = Logger();

  // @override
  // Stream<MyRecentSearchState> mapEventToState(
  //   MyRecentSearchEvent event,
  // ) async* {
  //   if(event is GetMyRecentSearch){
  //     yield* _getMyRecentSearch();
  //   }
  //   if(event is LoadMyRecentSearch){
  //     yield* _loadMyRecentSearch();
  //   }
  //   if(event is DeleteMyRecentSearch){
  //     yield* _deleteMyRecentSearch();
  //   }
  // }

  void _getMyRecentSearch(MyRecentSearchEvent event, Emitter<MyRecentSearchState> emit) async {
    final myRecentSearchBox = Hive.box("myRecentSearch");

    List<dynamic> registeredList = myRecentSearchBox.values.toList();

    for(var element in registeredList){
      MyRecentSearch rList = element as MyRecentSearch;

      myRecentList.add(rList);
      logger.i(rList);
    }
    emit(const MyRecentSearchDone());
  }

  void _deleteMyRecentSearch(DeleteMyRecentSearch event, Emitter<MyRecentSearchState> emit) async {
    final myRecentSearchBox = Hive.box("myRecentSearch");
    await myRecentSearchBox.deleteAt(event.index!);
    emit(const MyRecentSearchDone());
  }

  void _loadMyRecentSearch(LoadMyRecentSearch event, Emitter<MyRecentSearchState> emit) async {
    emit(const MyRecentSearchLoading());
  }
}
