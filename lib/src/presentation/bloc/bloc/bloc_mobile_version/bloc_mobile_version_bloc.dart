import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/mobile_version/mobile_version_use_case.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'bloc_mobile_version_event.dart';
part 'bloc_mobile_version_state.dart';

class MobileVersionBloc extends Bloc<MobileVersionEvent, MobileVersionState> {
  final MobileVersionUseCase mobileVersionUseCase;

  MobileVersionBloc(this.mobileVersionUseCase) : super(const GetMobileVersionState()) {
    on<GetMobileVersionEvent>(_getMobileVersionEvent);
  }
  bool? isLatest;
  String thisVersion = '';
  String serverVersion = '';
  String updateUrl = '';
  bool isLoading = false;

  // Stream<MobileVersionState> mapEventToState(MobileVersionEvent event,) async* {
  //   if(event is GetMobileVersionEvent){
  //     yield* _getMobileVersionEvent();
  //   }
  // }


  void _getMobileVersionEvent(MobileVersionEvent event, Emitter<MobileVersionState> emit) async {

    final dataState = await mobileVersionUseCase();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if(dataState.data != null){
      serverVersion = dataState.data!.mobileVersionEntity!.version.toString();
      String versionNotes = dataState.data!.mobileVersionEntity!.versionNotes.toString();
      updateUrl = dataState.data!.mobileVersionEntity!.updateUrl.toString();
      thisVersion = packageInfo.version;

      // yield const GetMobileVersionDone();
      emit(const GetMobileVersionDone());
    }

    // GetPreferences().getMobileVersionPref();
    if(dataState is DataFailed){
      // yield AuthError(dataState.error as DioError);
      emit(AuthError(dataState.error as DioError));
    }
  }

}
