part of 'members_under_co_bloc.dart';

abstract class MembersUnderCoState extends Equatable {
  const MembersUnderCoState();

  @override
  List<Object?> get props => [];
}

class MembersUnderCoLoading extends MembersUnderCoState {
  const MembersUnderCoLoading();
}

class GetMembersUnderCoDone extends MembersUnderCoState{
  const GetMembersUnderCoDone();
}