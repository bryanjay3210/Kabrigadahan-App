import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kabrigadan_mobile/src/core/bloc/bloc_with_state.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising/fundraising_item_fundraising.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising/specific_fundraising.dart';
import 'package:kabrigadan_mobile/src/domain/entities/newsfeed/newsfeed.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/fundraising/fundraising_usecase.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/fundraising/total_count.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/fundraising_attachment/fundraising_attachment_use_case.dart';
import 'package:logger/logger.dart';

part 'fundraising_event.dart';
part 'fundraising_state.dart';

class FundraisingBloc extends BlocWithState<FundraisingEvent, FundraisingState> with HydratedMixin {
  final GetFundraisingUseCase _getFundraisingUseCase;
  final GetTotalCountUseCase _getTotalCountUseCase;
  final GetFundraisingAttachmentUseCase _getFundraisingAttachmentUseCase;

  FundraisingBloc(this._getFundraisingUseCase, this._getFundraisingAttachmentUseCase, this._getTotalCountUseCase) : super(const FundraisingLoading()){
    on<GetFundraising>(_getFundraisingEvent);
    on<LoadFundraising>(_loadFundraising);
  }
  int currentIndex = 0;
  static int? skipCount = 0;
  List<NewsFeed> cachedListNewsFeed = [];
  TextEditingController controller = TextEditingController();
  var logger = Logger();
  @override
  FundraisingState? fromJson(Map<String, dynamic> json) {
    try{
      for(var element in json['fundraisings']){
        NewsFeed newsFeed = NewsFeed.fromJson(element);
        cachedListNewsFeed.add(newsFeed);
      }
    }catch(_){
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(FundraisingState state) {
    List<Map<String, dynamic>> listJsonNewsfeed = [];

    if(state is FundraisingDone){
      Map<String, List<NewsFeed>> listNewsFeed = {'fundraisings' : state.listNewsFeed};
      return listNewsFeed;
    } else{
      return null;
    }
  }

  // @override
  // Stream<FundraisingState> mapEventToState(
  //   FundraisingEvent event,
  // ) async* {
  //   if(event is GetFundraising) {
  //     yield* _getFundraisingEvent(event);
  //   }
  //
  //   if(event is LoadFundraising){
  //     yield* _loadFundraising();
  //   }
  // }

  void _getFundraisingEvent(FundraisingEvent event, Emitter<FundraisingState> emit) async {

      List<NewsFeed>? tempNewsFeedList = [];
      final superDataState = await _getTotalCountUseCase();

      final dataState = await _getFundraisingUseCase(params: skipCount, query: controller.text.toUpperCase());

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        if(dataState is DataSuccess && dataState.data != null) {
          final _fundraising = dataState.data;

          bool noMoreData = superDataState.data != null ? int.parse(superDataState.data.toString()) < 10 || _fundraising!.length >= int.parse(superDataState.data.toString()) : false;
          skipCount = skipCount! + 10;

          // List<NewsFeed> _tempNewsFeedList = [];

          if(_fundraising != null){
            for(var i in _fundraising){
              FundraisingItemFundraising _eachFundraising = i;
              SpecificFundraising _fundraisingItem = _eachFundraising.fundRaising!.fundraising!;
              var _fundraisingId = _fundraisingItem.id;

              final fundraisingAttachmentState = await _getFundraisingAttachmentUseCase(params: _fundraisingId);

              if(fundraisingAttachmentState is DataSuccess && fundraisingAttachmentState.data != null){

                //TODO: USE ENUM INSTEAD OF EQUATING TO 3 OR 2
                //REMINDER: SHOW ACTIVE FUNDRAISING ONLY
                if(fundraisingAttachmentState.data!.fundraisingAttachmentDetails!.fundraising!.status != 3){
                  final _newsFeed = NewsFeed(_eachFundraising, fundraisingAttachmentState.data);
                  tempNewsFeedList.add(_newsFeed);
                }
              }
            }
          }

          // _listFundraisingItems.addAll(_fundraising);
          emit(FundraisingDone(List.of(state.listNewsFeed)..addAll(tempNewsFeedList), noMoreData: noMoreData));
        }

        if(dataState is DataFailed){
          // yield FundraisingError(dataState.error as DioError);
          emit(FundraisingError(dataState.error as DioError));
        }
      } else {
        emit(FundraisingDone(cachedListNewsFeed, noMoreData: true));
      }

  }

  void _loadFundraising(FundraisingEvent event, Emitter<FundraisingState> emit) async{
    emit(const FundraisingLoading());
  }
}
