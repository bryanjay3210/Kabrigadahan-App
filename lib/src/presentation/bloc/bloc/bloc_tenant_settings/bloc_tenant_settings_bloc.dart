import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/get_preferences.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/store_preferences.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/tenant_settings/tenant_settings_use_case.dart';
import 'package:logger/logger.dart';

part 'bloc_tenant_settings_event.dart';
part 'bloc_tenant_settings_state.dart';

class TenantSettingsBloc extends Bloc<TenantSettingsEvent, TenantSettingsState> {
  final TenantSettingsUseCase tenantSettingsUseCase;

  TenantSettingsBloc(this.tenantSettingsUseCase) : super(const GetTenantSettingsState()){
    on<GetTenantSettingsEvent>(_getTenantSettings);
  }

  // @override
  // Stream<TenantSettingsState> mapEventToState(TenantSettingsEvent event,) async* {
  //   if(event is GetTenantSettingsEvent){
  //     yield* _getTenantSettings();
  //   }
  // }

  void _getTenantSettings(GetTenantSettingsEvent event, Emitter<TenantSettingsState> emit) async {
    var logger = Logger();
    final dataState = await tenantSettingsUseCase();

    if(dataState.data != null){
      String brigadahanFundsCode = dataState.data!.brigadahanFundsCodeEntity!.brigadahanFoundationFundsCode.toString();
      String brigadahanFundsRecipient = dataState.data!.brigadahanFundsCodeEntity!.brigadahanFoundationFundsRecipient.toString();
      String brigadahanFoundationTenantCodeAlias = dataState.data!.brigadahanFundsCodeEntity!.brigadahanFoundationTenantCodeAlias.toString();

      StorePreferences().storeBrigadahanFoundationFundsSettings(brigadahanFundsCode, brigadahanFundsRecipient, brigadahanFoundationTenantCodeAlias);
    }

    GetPreferences().getBrigadahanFoundationFundsSettings();
    if(dataState is DataFailed){
      emit(AuthError(dataState.error as DioError));
    }
    logger.i(dataState);
  }
}
