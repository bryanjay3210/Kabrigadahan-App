import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/params/current_user/current_user_params.dart';
import 'package:kabrigadan_mobile/src/core/utils/dropdown_data/dropdown_data.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/get_preferences.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/members_under_co.dart';
import 'package:kabrigadan_mobile/src/domain/entities/current_user/current_user_entity.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/current_user/members_under_co_usecase.dart';
import 'package:logger/logger.dart';

part 'members_under_co_event.dart';

part 'members_under_co_state.dart';

class MembersUnderCoBloc extends Bloc<MembersUnderCoEvent, MembersUnderCoState> {
  final GetMemberUnderCOUseCase getMemberUnderCOUseCase;

  MembersUnderCoBloc(this.getMemberUnderCOUseCase) : super(const MembersUnderCoLoading()){
    on<GetMembersUnderCoEvent>(_getMembersUnderCo);
    on<MembersUnderCoLoadingEvent>(_loadMembersUnderCo);
  }

  // @override
  // Stream<MembersUnderCoState> mapEventToState(
  //   MembersUnderCoEvent event,
  // ) async* {
  //   if (event is GetMembersUnderCoEvent) {
  //     yield* _getMembersUnderCo();
  //   }
  //
  //   if (event is MembersUnderCoLoadingEvent) {
  //     yield* _loadMembersUnderCo();
  //   }
  // }

  void _getMembersUnderCo(GetMembersUnderCoEvent event, Emitter<MembersUnderCoState> emit) async {
    var logger = Logger();
    final memberUnderCOBox = Hive.box('memberListCO');
    var memberUnderCOList = memberUnderCOBox.values.toList();
    emit(const MembersUnderCoLoading());

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      int? userId = await GetPreferences().getStoredUserId();
      final accessToken = await GetPreferences().getStoredAccessToken();
      final String header = "Bearer $accessToken";
      final membersUnderDOData = await getMemberUnderCOUseCase(params: CurrentUserParams(header: header, userId: userId!));

      DropdownData.mapMember.clear();
      DropdownData.mapMemberName.clear();

      if(membersUnderDOData.data != null){

        List<CurrentUserEntity>? list = membersUnderDOData.data;

        for(var element in list!){
          CurrentUserEntity mlist = element;
          String? memberId = mlist.idNumber;
          String? memberName = mlist.name;

          Map<String, dynamic> map = {
            "memberId" : memberId,
            "memberName": memberName
          };

          DropdownData.mapMember.add(map);
          DropdownData.mapMemberName.add(memberName!);
        }

        memberUnderCOBox.clear();

        for (CurrentUserEntity element in list) {
          MembersUnderCO membersUnderCO = MembersUnderCO(
              name: element.name, assignedOfficer: element.assignedOfficer, barangay: element.barangay, purok: element.purok,
              birthDate: element.birthDate,cityQrCodeId: element.cityQrCodeId, idNumber: element.idNumber, imageFileToken: element.imageFileToken,
              memberId: element.memberId, membershipLevel: element.membershipLevel, mobileNumber: element.mobileNumber);
          memberUnderCOBox.add(membersUnderCO);
        }
      }
    } else {
      DropdownData.mapMember.clear();
      DropdownData.mapMemberName.clear();
      for(var element in memberUnderCOList){
        MembersUnderCO mlist = element as MembersUnderCO;
        String? memberId = mlist.idNumber;
        String? memberName = mlist.name;

        Map<String, dynamic> map = {
          "memberId" : memberId,
          "memberName": memberName
        };

        DropdownData.mapMember.add(map);
        DropdownData.mapMemberName.add(memberName!);
      }
    }
    emit(const GetMembersUnderCoDone());
  }

  void _loadMembersUnderCo(MembersUnderCoLoadingEvent event, Emitter<MembersUnderCoState> emit) async {
    emit(const MembersUnderCoLoading());
  }
}
