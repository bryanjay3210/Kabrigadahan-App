import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/create_member_unremitted_offline/create_member_unremitted_offline_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/get_preferences.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/my_unremitted_donation/my_unremitted_donation.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation_ui/unremitted_donation_ui.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation_fromserver.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/member_unremitted_donation_model/member_unremitted_donation_model.dart';
import 'package:kabrigadan_mobile/src/domain/entities/donations/donations_entity.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/get_unremitted_entities.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/member_unremitted_donation_results.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/donations/donations_usecase.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/mobile_transaction/mobile_transaction_use_case.dart';

part 'donations_event.dart';
part 'donations_state.dart';

class DonationsBloc extends HydratedBloc<DonationsEvent, DonationsState> {
  final GetDonationsUseCase _getDonationsUseCase;
  final CreateMemberUnRemittedDonationForOfflineUseCase _createMemberUnRemittedDonationForOfflineUseCase;

  DonationsBloc(this._getDonationsUseCase, this._createMemberUnRemittedDonationForOfflineUseCase) : super(const DonationsLoading()){
    on<GetDonationsEvent>(_getDonations);
    on<DonationsLoadingEvent>(_loadDonations);
  }

  @override
  DonationsState? fromJson(Map<String, dynamic> json) {
    try{
      final currentUser = DonationsEntity.fromJson(json);
      return DonationsDone(currentUser);
    }catch(_){
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(DonationsState state) {
    if(state is DonationsDone || state is DonationsDone){
      return state.donationsEntity!.toJson();
    } else{
      return null;
    }
  }

  // @override
  // Stream<DonationsState> mapEventToState(
  //   DonationsEvent event,
  //   ) async* {
  //
  //   if(event is GetDonationsEvent) {
  //     yield* _getDonations();
  //   }
  //
  //   if(event is DonationsLoadingEvent){
  //     yield* _loadDonations();
  //   }
  // }

  void _getDonations(GetDonationsEvent event, Emitter<DonationsState> emit) async{
    final myUnremittedDonationsBox = Hive.box('myUnremittedDonations');
    final unremittedDonationUiBox = Hive.box('unremittedDonationsUi');
    final currentUserBox = Hive.box('currentUser');

    String? accessToken = await GetPreferences().getStoredAccessToken();

    String headers = "Bearer ${accessToken!}";
    final dataState = await _getDonationsUseCase(params: headers);
    if(dataState.data != null){

      if(currentUserBox.isNotEmpty){
        List<dynamic> myUnremittedDonationsBoxList = myUnremittedDonationsBox.values.toList();
        List<dynamic> unremittedDonationUiList = unremittedDonationUiBox.values.toList();

        CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

        ///DONOR SYNCING
        // await syncDonorUnremittedDonations();

        ///CO SYNCING
        await syncCOUnremittedDonations();
      }

      emit(DonationsDone(dataState.data!));
    }
  }

  // Future<void> syncDonorUnremittedDonations() async {
  //   var logger = Logger();
  //   final myUnremittedDonationsBox = Hive.box('myUnremittedDonations');
  //   final currentUserBox = Hive.box('currentUser');
  //   final myUnremittedFromServerBox = Hive.box('unremittedDonationsFromServer');
  //
  //   List<dynamic> myUnremittedDonationsFromServerBoxList = myUnremittedFromServerBox.values.toList();
  //   List<dynamic> myUnremittedDonationsBoxList = myUnremittedDonationsBox.values.toList();
  //
  //   CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;
  //
  //   List<Map<String, dynamic>> jsonList = [];
  //   for (var i in myUnremittedDonationsBoxList) {
  //     MyUnremittedDonation myUnremittedDonation = i as MyUnremittedDonation;
  //     if (myUnremittedDonation.creatorId == currentUser.memberId) {
  //       Map<String, dynamic> jsonMyUnremitted = myUnremittedDonation.toJson();
  //       jsonList.add(jsonMyUnremitted);
  //     }
  //   }
  //
  //   List<String> donationIds = [];
  //   for (var element in myUnremittedDonationsFromServerBoxList) {
  //     UnremittedDonationFromServer unremittedDonationFromServer = element as UnremittedDonationFromServer;
  //     donationIds.add(unremittedDonationFromServer.id!);
  //   }
  //
  //   String? accessToken = await GetPreferences().getStoredAccessToken();
  //
  //   String headers = "Bearer ${accessToken!}";
  //
  //   final donationState = await _createMemberUnRemittedDonationForOfflineUseCase(params: CreateMemberUnremittedOfflineParams(jsonList));
  //
  //   MyUnremittedDonationsParams myUnremittedDonationsParams = MyUnremittedDonationsParams(header: headers, checkStatusOfExistingDonationIds: donationIds);
  //   final getCurrentUnremittedDataState = await _getCurrentUnRemittedUseCase(params: myUnremittedDonationsParams);
  //
  //   if(getCurrentUnremittedDataState.data != null){
  //     for(GetUnremittedEntities element in getCurrentUnremittedDataState.data!){
  //       if(myUnremittedDonationsFromServerBoxList.isNotEmpty){
  //         for(var hiveElement in myUnremittedDonationsFromServerBoxList){
  //           UnremittedDonationFromServer unremittedDonationFromServer = hiveElement as UnremittedDonationFromServer;
  //           //if item doesn't exist on local box, add the item to local
  //           if(element.unremittedTempId != unremittedDonationFromServer.unremittedTempId){
  //             addToMyUnremittedFromServerBox(element, myUnremittedFromServerBox);
  //           }
  //         }
  //       } else{
  //         addToMyUnremittedFromServerBox(element, myUnremittedFromServerBox);
  //       }
  //     }
  //   }
  //
  //
  //   //TODO: DATA AFTER GET METHOD ON DONATIONS OFFLINE
  //   if(donationState.data != null){
  //     _updateIdAndStatus(myUnremittedDonationsBoxList, donationState);
  //   }
  //
  //
  //   //Remove item if status is Remitted
  //   for(int i=0; i<myUnremittedDonationsBoxList.length; i++){
  //     MyUnremittedDonation myUnremittedDonation = myUnremittedDonationsBoxList[i] as MyUnremittedDonation;
  //     if (myUnremittedDonation.status == 3) {
  //       int index = i;
  //       myUnremittedDonationsBox.deleteAt(index);
  //     }
  //   }
  // }

  void addToMyUnremittedFromServerBox(GetUnremittedEntities element, Box<dynamic> myUnremittedFromServerBox) {
    UnremittedDonationFromServer _unRemittedFromServer = UnremittedDonationFromServer(
        caseCode: element.caseCode,
        amount: double.parse(element.amount.toString()),
        donatedByMemberIdNumber: element.donatedByMemberIdNumber,
        agentMemberIdNumber: element.agentMemberIdNumber,
        status: element.status,
        memberRemittanceMasterId: element.memberRemittanceMasterId,
        ayannahAttachment: element.ayannahAttachment,
        unremittedTempId: element.unremittedTempId,
        id: element.id
    );

    myUnremittedFromServerBox.add(_unRemittedFromServer);
  }

  Future<void> syncCOUnremittedDonations() async {
    final unremittedDonationUiBox = Hive.box('unremittedDonationsUi');
    final currentUserBox = Hive.box('currentUser');

    List<dynamic> unremittedDonationUiList = unremittedDonationUiBox.values.toList();
    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

    List<Map<String, dynamic>> jsonCOList = [];
    for (var i in unremittedDonationUiList) {
      UnremittedDonationUi unremittedDonationUi = i as UnremittedDonationUi;
      if (unremittedDonationUi.creatorId == currentUser.memberId) {
        Map<String, dynamic> jsonCOUnremitted = unremittedDonationUi.toJsonSyncing();
        jsonCOList.add(jsonCOUnremitted);
      }
    }

    final donationCOState = await _createMemberUnRemittedDonationForOfflineUseCase(params: CreateMemberUnremittedOfflineParams(jsonCOList));

    if(donationCOState.data != null){
      _updateIdAndStatusCO(unremittedDonationUiList, donationCOState);
    }

    //Remove item if status is Remitted
    for(int i=0; i<unremittedDonationUiList.length; i++){
      UnremittedDonationUi unremittedDonation = unremittedDonationUiList[i] as UnremittedDonationUi;
      if (unremittedDonation.status == 3) {
        int index = i;
        unremittedDonationUiBox.deleteAt(index);
      }
    }
  }

  void _updateIdAndStatus(List<dynamic> myUnremittedDonationsBoxList, DataState<List<MemberUnremittedDonationResultsEntity>> donationState) {
    for (var i in myUnremittedDonationsBoxList) {
      MyUnremittedDonation myUnremittedDonation = i as MyUnremittedDonation;

      for(var j in donationState.data!){
        MemberUnremittedDonationModel memberUnremittedDonationModel = j as MemberUnremittedDonationModel;

        if(memberUnremittedDonationModel.unremittedTempId == myUnremittedDonation.unremittedTempId){
          String replacementId = memberUnremittedDonationModel.id.toString();
          int replacementStatus = memberUnremittedDonationModel.status!;
          myUnremittedDonation.id = replacementId;
          myUnremittedDonation.status = replacementStatus;
        }
      }
    }
  }

  void _updateIdAndStatusCO(List<dynamic> unremittedDonationsBoxList, DataState<List<MemberUnremittedDonationResultsEntity>> donationState) {
    for (var i in unremittedDonationsBoxList) {
      UnremittedDonationUi unremittedDonation = i as UnremittedDonationUi;

      for(var j in donationState.data!){
        MemberUnremittedDonationModel memberUnremittedDonationModel = j as MemberUnremittedDonationModel;

        if(memberUnremittedDonationModel.unremittedTempId == unremittedDonation.unremittedTempId){
          String replacementId = memberUnremittedDonationModel.id.toString();
          int replacementStatus = memberUnremittedDonationModel.status!;
          unremittedDonation.id = replacementId;
          unremittedDonation.status = replacementStatus;
        }
      }
    }
  }

  void _loadDonations(DonationsLoadingEvent event, Emitter<DonationsState> emit) async{
    emit(const DonationsLoading());
  }
}
