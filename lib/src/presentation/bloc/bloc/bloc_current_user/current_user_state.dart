part of 'current_user_bloc.dart';

abstract class CurrentUserState extends Equatable {
  final CurrentUserEntity? currentUserEntity;
  final List<CurrentUserEntity>? currentUserEntityList;

  const CurrentUserState({this.currentUserEntityList, this.currentUserEntity});

  @override
  List<Object?> get props => [];
}

class GetCurrentUserLoading extends CurrentUserState {
  const GetCurrentUserLoading();
}

class GetCurrentUserDone extends CurrentUserState {
  const GetCurrentUserDone(CurrentUserEntity currentUserEntity) : super(currentUserEntity: currentUserEntity);
}

class GetCurrentUserDoneWithoutProfilePicture extends CurrentUserState {
  const GetCurrentUserDoneWithoutProfilePicture();
}

class GetMembersUnderCODone extends CurrentUserState {
  const GetMembersUnderCODone();
}