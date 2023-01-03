import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kabrigadan_mobile/src/core/params/current_user/current_user_params.dart';
import 'package:kabrigadan_mobile/src/core/params/current_user/current_user_profile_picture_params.dart';
import 'package:kabrigadan_mobile/src/core/utils/dropdown_data/dropdown_data.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/get_preferences.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/members_under_co.dart';
import 'package:kabrigadan_mobile/src/domain/entities/current_user/current_user_entity.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/current_user/current_user_usecase.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/current_user/members_under_co_usecase.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/current_user/profile_picture.dart';

part 'current_user_event.dart';
part 'current_user_state.dart';

class CurrentUserBloc extends HydratedBloc<CurrentUserEvent, CurrentUserState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetCurrentUserProfilePictureUseCase _getCurrentUserProfilePictureUseCase;
  final GetMemberUnderCOUseCase _getMemberUnderCOUseCase;

  CurrentUserBloc(this._getCurrentUserUseCase, this._getCurrentUserProfilePictureUseCase, this._getMemberUnderCOUseCase) : super(const GetCurrentUserLoading()){
    on<GetCurrentUserEvent>(_getCurrentUser);
    on<LoadCurrentUser>(_loadCurrentUser);
  }
  CurrentUserEntity? currentUserEntity;

  @override
  CurrentUserState? fromJson(Map<String, dynamic> json) {
    try{
      final currentUser = CurrentUserEntity.fromJson(json);
      return GetCurrentUserDone(currentUser);
    }catch(_){
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CurrentUserState state) {
    if(state is GetCurrentUserDone || state is GetMembersUnderCODone){
      if(state.currentUserEntity != null){
        return state.currentUserEntity!.toJson();
      } else {
        return null;
      }
    } else{
      return null;
    }
  }

  // @override
  // Stream<CurrentUserState> mapEventToState(
  //   CurrentUserEvent event,
  //   ) async* {
  //     if(event is GetCurrentUserEvent) {
  //       yield* _getCurrentUser();
  //     }
  //
  //     if(event is LoadCurrentUser) {
  //       yield* _loadCurrentUser();
  //     }
  // }

  void _getCurrentUser(GetCurrentUserEvent event, Emitter<CurrentUserState> emit) async {
    await Hive.openBox('currentUser');
    await Hive.openBox('membersUnderCO');
    final currentUserBox = Hive.box('currentUser');
    final memberUnderCOBox = Hive.box('memberListCO');
    var memberUnderCOList = memberUnderCOBox.values.toList();
    int? userId = await GetPreferences().getStoredUserId();
    final accessToken = await GetPreferences().getStoredAccessToken();

    final String header = "Bearer $accessToken";
    final dataState = await _getCurrentUserUseCase(params: CurrentUserParams(header: header, userId: userId!));

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      int? userId = await GetPreferences().getStoredUserId();
      final accessToken = await GetPreferences().getStoredAccessToken();
      final String header = "Bearer $accessToken";
      final membersUnderDOData = await _getMemberUnderCOUseCase(params: CurrentUserParams(header: header, userId: userId!));

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

    if(dataState.data != null){
      final data = dataState.data!;
      String imageFileToken = data.imageFileToken!;
      final profilePictureData = await _getCurrentUserProfilePictureUseCase(params: CurrentUserProfilePictureParams(imageTokenId: imageFileToken));
      if(profilePictureData.data != null){
        CurrentUser currentUser = CurrentUser(
            name: data.name,
            profilepicture: profilePictureData.data!.fileToken,
            barangay: data.barangay,
            purok: data.purok,
            mobileNumber: data.mobileNumber,
            imageFileToken: data.imageFileToken,
            memberId: data.memberId,
            idNumber: data.idNumber,
            birthdate: DateTime.parse(data.birthDate!),
            membershipLevel: data.membershipLevel,
            assignedOfficer: data.assignedOfficer
        );

        currentUserEntity = dataState.data!;
        currentUserBox.add(currentUser);
        emit(GetCurrentUserDone(dataState.data!));
      } else {
        CurrentUser currentUser = CurrentUser(
            name: data.name,
            profilepicture: null,
            barangay: data.barangay,
            purok: data.purok,
            mobileNumber: data.mobileNumber,
            imageFileToken: data.imageFileToken,
            memberId: data.memberId,
            idNumber: data.idNumber,
            birthdate: DateTime.parse(data.birthDate!),
            membershipLevel: data.membershipLevel,
            assignedOfficer: data.assignedOfficer
        );
        currentUserEntity = dataState.data!;
        currentUserBox.add(currentUser);
        emit(GetCurrentUserDone(dataState.data!));
      }
    } else{

    }
  }

  void _loadCurrentUser(LoadCurrentUser event, Emitter<CurrentUserState> emit) async {
    emit(const GetCurrentUserLoading());
  }
}
