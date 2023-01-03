part of 'fundraising_bloc.dart';

abstract class FundraisingState extends Equatable {
  final List<NewsFeed> listNewsFeed;
  final DioError? error;
  final bool? noMoreData;

  const FundraisingState({this.listNewsFeed = const <NewsFeed>[], this.error, this.noMoreData});

  @override
  List<Object?> get props => [listNewsFeed, error, noMoreData];
}

class FundraisingLoading extends FundraisingState {
  const FundraisingLoading();
}

class FundraisingDone extends FundraisingState {
  const FundraisingDone(List<NewsFeed> listNewsFeed, {required bool noMoreData}) : super(listNewsFeed: listNewsFeed, noMoreData: noMoreData);
}

class FundraisingError extends FundraisingState {
  const FundraisingError(DioError error) : super(error: error);
}