part of 'current_user_bloc.dart';

abstract class CurrentUserEvent extends Equatable {
  const CurrentUserEvent();

  @override
  List<Object?> get props => [];
}

class GetCurrentUserEvent extends CurrentUserEvent{
  const GetCurrentUserEvent();
}

class LoadCurrentUser extends CurrentUserEvent{
  const LoadCurrentUser();
}

class GetMembersUnderCOEvent extends CurrentUserEvent{
  const GetMembersUnderCOEvent();
}