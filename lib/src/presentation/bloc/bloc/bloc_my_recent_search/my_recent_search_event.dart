part of 'my_recent_search_bloc.dart';

abstract class MyRecentSearchEvent extends Equatable {
  const MyRecentSearchEvent();

  @override
  List<Object> get props => [];
}


class GetMyRecentSearch extends MyRecentSearchEvent {
  const GetMyRecentSearch();
}

class LoadMyRecentSearch extends MyRecentSearchEvent {
  const LoadMyRecentSearch();
}

class DeleteMyRecentSearch extends MyRecentSearchEvent {
  final int? index;
  const DeleteMyRecentSearch(this.index);
}