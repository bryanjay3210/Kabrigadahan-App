import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/bloc/bloc_with_state.dart';
import 'package:kabrigadan_mobile/src/core/params/donations/get_unremitted_donation_current_user_params.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/create_member_unremitted_offline/create_member_unremitted_offline_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/get_preferences.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/my_unremitted_donation/my_unremitted_donation.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation_fromserver.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation_ui/unremitted_donation_ui.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/get_member_unremitted_donation_offline/get_member_unremitted_donation_offline_model.dart';
import 'package:kabrigadan_mobile/src/data/models/mobile_transaction/received/member_unremitted_donation_model/member_unremitted_donation_model.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/get_unremitted_entities.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/member_unremitted_donation_results.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/donations/donations_usecase.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/mobile_transaction/mobile_transaction_use_case.dart';
import 'package:logger/logger.dart';

part 'sync_donations_event.dart';

part 'sync_donations_state.dart';

class SyncDonationsBloc extends BlocWithState<SyncDonationsEvent, SyncDonationsState> {
  final GetDonationsUseCase _getDonationsUseCase;
  final GetCurrentUnRemittedUseCase _getCurrentUnRemittedUseCase;
  final CreateMemberUnRemittedDonationForOfflineUseCase _createMemberUnRemittedDonationForOfflineUseCase;

  SyncDonationsBloc(this._getDonationsUseCase, this._getCurrentUnRemittedUseCase, this._createMemberUnRemittedDonationForOfflineUseCase) : super(SyncDonationsInitial()){
    on<PostSyncDonationsDonorEvent>(addDonationsDonor);
    on<PostSyncButtonDonationsDonorEvent>(syncDonationsDonor);
    on<PostSyncDonationsCOEvent>(syncDonationsCO);
  }


  static int? syncSkipCount = 0;
  bool noMoreData = false;

  // @override
  // Stream<SyncDonationsState> mapEventToState(SyncDonationsEvent event) async* {
  //   if (event is PostSyncDonationsDonorEvent) {
  //     yield* addDonationsDonor();
  //   }
  //
  //   if(event is PostSyncButtonDonationsDonorEvent){
  //     yield* syncDonationsDonor();
  //   }
  //
  //   if (event is PostSyncDonationsCOEvent) {
  //     yield* syncDonationsCO();
  //   }
  // }

  void addDonationsDonor(PostSyncDonationsDonorEvent event, Emitter<SyncDonationsState> emit) async {
      // yield const SyncLoadingDonationsState();
      var logger = Logger();
      final myUnremittedDonationsBox = Hive.box('myUnremittedDonations');
      final currentUserBox = Hive.box('currentUser');
      final myUnremittedFromServerBox = Hive.box('unremittedDonationsFromServer');

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        myUnremittedFromServerBox.clear();
        List<dynamic> myUnremittedDonationsFromServerBoxList = myUnremittedFromServerBox.values.toList();
        List<dynamic> myUnremittedDonationsBoxList = myUnremittedDonationsBox.values.toList();

        List<UnremittedDonationFromServer> myUnremittedDonationsFromServerList = [];
        List<UnremittedDonationFromServer> myUnremittedDonationsOfflineList = [];

        CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

        List<Map<String, dynamic>> jsonList = [];
        for (var i in myUnremittedDonationsBoxList) {
          MyUnremittedDonation myUnremittedDonation = i as MyUnremittedDonation;
          if (myUnremittedDonation.creatorId == currentUser.memberId) {
            Map<String, dynamic> jsonMyUnremitted = myUnremittedDonation.toJson();
            jsonList.add(jsonMyUnremitted);
          }
        }

        List<String> donationIds = [];
        for (var element in myUnremittedDonationsFromServerBoxList) {
          UnremittedDonationFromServer unremittedDonationFromServer = element as UnremittedDonationFromServer;
          donationIds.add(unremittedDonationFromServer.id!);
        }
        String? accessToken = await GetPreferences().getStoredAccessToken();
        String headers = "Bearer ${accessToken!}";

        final donationState = await _createMemberUnRemittedDonationForOfflineUseCase(params: CreateMemberUnremittedOfflineParams(jsonList));

        GetUnremittedDonationsCurrentUserParams getUnremittedDonationsCurrentUserParams = GetUnremittedDonationsCurrentUserParams(header: headers, checkStatusOfExistingDonationIds: [],
            skipCount: syncSkipCount);

        final getCurrentUnremittedDataState = await _getCurrentUnRemittedUseCase(params: getUnremittedDonationsCurrentUserParams);

      if(getCurrentUnremittedDataState.data != null && getCurrentUnremittedDataState.data!.isNotEmpty){
        noMoreData = false;
        syncSkipCount = syncSkipCount! + 10;
        logger.i('get current unremitted');

          for(GetMemberUnremittedDonationModel element in getCurrentUnremittedDataState.data!){
            Map<String, dynamic> jsonMemberUnremitted = element.toJson();
            UnremittedDonationFromServer unremittedDonationFromServer = UnremittedDonationFromServer.fromJson(jsonMemberUnremitted);

            myUnremittedDonationsFromServerList.add(unremittedDonationFromServer);

            await addToMyUnremittedFromServerBox(element, myUnremittedFromServerBox);
          }
        } else if (getCurrentUnremittedDataState.data!.isEmpty){
          noMoreData = true;
        }

        emit(SyncDoneDonorDonationState(List.of(state.listUnremittedDonationServer)..addAll(myUnremittedDonationsFromServerList), noMoreData));

        //TODO: DATA AFTER GET METHOD ON DONATIONS OFFLINE
        if(donationState.data != null){
          _updateIdAndStatus(myUnremittedDonationsBoxList, donationState);
        }

        //Remove item if status is Remitted
        for(int i=0; i<myUnremittedDonationsBoxList.length; i++){
          MyUnremittedDonation myUnremittedDonation = myUnremittedDonationsBoxList[i] as MyUnremittedDonation;
          if (myUnremittedDonation.status == 3) {
            int index = i;
            myUnremittedDonationsBox.deleteAt(index);
          }
        }
      } else {
        List<dynamic> myUnremittedDonationsFromServerBoxList = myUnremittedFromServerBox.values.toList();
        List<dynamic> myUnremittedDonationsBoxList = myUnremittedDonationsBox.values.toList();

        List<UnremittedDonationFromServer> myUnremittedDonationsFromServerList = [];
        List<UnremittedDonationFromServer> myUnremittedDonationsOfflineList = [];

        CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

        List<Map<String, dynamic>> jsonList = [];
        for (var i in myUnremittedDonationsBoxList) {
          MyUnremittedDonation myUnremittedDonation = i as MyUnremittedDonation;
          if (myUnremittedDonation.creatorId == currentUser.memberId) {
            Map<String, dynamic> jsonMyUnremitted = myUnremittedDonation.toJson();
            jsonList.add(jsonMyUnremitted);
          }
        }

        List<String> donationIds = [];
        for (var element in myUnremittedDonationsFromServerBoxList) {
          UnremittedDonationFromServer unremittedDonationFromServer = element as UnremittedDonationFromServer;
          donationIds.add(unremittedDonationFromServer.id!);
        }

        for(var element in myUnremittedDonationsFromServerBoxList){
          UnremittedDonationFromServer unremittedDonationOffline = element as UnremittedDonationFromServer;
          myUnremittedDonationsOfflineList.add(unremittedDonationOffline);
        }
        emit(SyncDoneDonorDonationState(List.of(state.listUnremittedDonationServer)..addAll(myUnremittedDonationsOfflineList), true));
      }
  }

  void syncDonationsDonor(PostSyncButtonDonationsDonorEvent event, Emitter<SyncDonationsState> emit) async {
    emit(const SyncLoadingDonationsState());

    var logger = Logger();
    final myUnremittedDonationsBox = Hive.box('myUnremittedDonations');
    final currentUserBox = Hive.box('currentUser');
    final myUnremittedFromServerBox = Hive.box('unremittedDonationsFromServer');

    List<dynamic> myUnremittedDonationsFromServerBoxList = myUnremittedFromServerBox.values.toList();
    List<dynamic> myUnremittedDonationsBoxList = myUnremittedDonationsBox.values.toList();

    List<UnremittedDonationFromServer> myUnremittedDonationsFromServerList = [];

    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

    List<Map<String, dynamic>> jsonList = [];
    for (var i in myUnremittedDonationsBoxList) {
      MyUnremittedDonation myUnremittedDonation = i as MyUnremittedDonation;
      if (myUnremittedDonation.creatorId == currentUser.memberId) {
        Map<String, dynamic> jsonMyUnremitted = myUnremittedDonation.toJson();
        jsonList.add(jsonMyUnremitted);
      }
    }

    List<String> donationIds = [];
    for (var element in myUnremittedDonationsFromServerBoxList) {
      UnremittedDonationFromServer unremittedDonationFromServer = element as UnremittedDonationFromServer;
      donationIds.add(unremittedDonationFromServer.id!);
    }

    String? accessToken = await GetPreferences().getStoredAccessToken();
    String headers = "Bearer ${accessToken!}";

    final donationState = await _createMemberUnRemittedDonationForOfflineUseCase(params: CreateMemberUnremittedOfflineParams(jsonList));

    GetUnremittedDonationsCurrentUserParams getUnremittedDonationsCurrentUserParams = GetUnremittedDonationsCurrentUserParams(header: headers, checkStatusOfExistingDonationIds: [],
        skipCount: syncSkipCount);

    final getCurrentUnremittedDataState = await _getCurrentUnRemittedUseCase(params: getUnremittedDonationsCurrentUserParams);

    if(getCurrentUnremittedDataState.data != null && getCurrentUnremittedDataState.data!.isNotEmpty){
      noMoreData = false;
      syncSkipCount = syncSkipCount! + 10;
      logger.i('get current unremitted');

      for(GetMemberUnremittedDonationModel element in getCurrentUnremittedDataState.data!){
        Map<String, dynamic> jsonMemberUnremitted = element.toJson();
        UnremittedDonationFromServer unremittedDonationFromServer = UnremittedDonationFromServer.fromJson(jsonMemberUnremitted);

        myUnremittedDonationsFromServerList.add(unremittedDonationFromServer);

        await addToMyUnremittedFromServerBox(element, myUnremittedFromServerBox);
      }
    } else if (getCurrentUnremittedDataState.data!.isEmpty){
      noMoreData = true;
    }

    emit(SyncDoneDonorDonationState(List.of(state.listUnremittedDonationServer)..addAll(myUnremittedDonationsFromServerList), noMoreData));

    //TODO: DATA AFTER GET METHOD ON DONATIONS OFFLINE
    if(donationState.data != null){
      _updateIdAndStatus(myUnremittedDonationsBoxList, donationState);
    }

    //Remove item if status is Remitted
    for(int i=0; i<myUnremittedDonationsBoxList.length; i++){
      MyUnremittedDonation myUnremittedDonation = myUnremittedDonationsBoxList[i] as MyUnremittedDonation;
      if (myUnremittedDonation.status == 3) {
        int index = i;
        myUnremittedDonationsBox.deleteAt(index);
      }
    }
  }

  void syncDonationsCO(PostSyncDonationsCOEvent event, Emitter<SyncDonationsState> emit) async {
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

  Future<void> addToMyUnremittedFromServerBox(GetUnremittedEntities element, Box<dynamic> myUnremittedFromServerBox) async {
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

    await myUnremittedFromServerBox.add(_unRemittedFromServer);
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
}
