part of 'my_recent_search_bloc.dart';

abstract class MyRecentSearchState extends Equatable {
  const MyRecentSearchState();

  @override
  List<Object?> get props => [];
}

class MyRecentSearchLoading extends MyRecentSearchState {
  const MyRecentSearchLoading();
}

class MyRecentSearchDone extends MyRecentSearchState {
  const MyRecentSearchDone();
}