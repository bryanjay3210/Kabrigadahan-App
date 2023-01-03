import 'members_under_co.dart';

class SuperMembersUnderCOModel{
  final List<MembersUnderCOModel>? membersUnderCOModelList;

  SuperMembersUnderCOModel({this.membersUnderCOModelList});

  factory SuperMembersUnderCOModel.fromJson(Map<String, dynamic> json){
    return SuperMembersUnderCOModel(
        membersUnderCOModelList: List<MembersUnderCOModel>.from((json['result'] as List<dynamic>).map((e) => MembersUnderCOModel.fromJson(e as Map<String, dynamic>)))
    );
  }
}