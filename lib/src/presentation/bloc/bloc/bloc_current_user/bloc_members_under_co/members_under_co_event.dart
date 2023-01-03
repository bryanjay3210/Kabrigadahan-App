part of 'members_under_co_bloc.dart';

abstract class MembersUnderCoEvent extends Equatable {
  const MembersUnderCoEvent();

  @override
  List<Object?> get props => [];
}

class GetMembersUnderCoEvent extends MembersUnderCoEvent{
  const GetMembersUnderCoEvent();
}

class MembersUnderCoLoadingEvent extends MembersUnderCoEvent{
  const MembersUnderCoLoadingEvent();
}
