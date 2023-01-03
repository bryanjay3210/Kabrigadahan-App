import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/params/auth/auth_params.dart';
import 'package:kabrigadan_mobile/src/core/params/current_user/current_user_params.dart';
import 'package:kabrigadan_mobile/src/core/params/current_user/current_user_profile_picture_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/core/utils/current_user_permission/current_user_permissions.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/delete_preferences.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/get_preferences.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/store_preferences.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/auth/auth_usecase.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/current_user/current_user_usecase.dart';
import 'package:kabrigadan_mobile/src/domain/usecases/current_user/profile_picture.dart';
import 'package:logger/logger.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetAuthUseCase _getAuthUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetCurrentUserProfilePictureUseCase _getCurrentUserProfilePictureUseCase;

  AuthBloc(this._getAuthUseCase, this._getCurrentUserUseCase, this._getCurrentUserProfilePictureUseCase) : super(const AuthLoading()){
    on<GetAuthentication>(_getAuthentication);
    on<LoginEvent>(_login);
    on<Logout>(_logout);
  }
  bool isLoading = false;

  // @override
  // Stream<AuthState> mapEventToState(
  //   AuthEvent event,
  // ) async* {
  //   if (event is GetAuthentication) {
  //     yield* _getAuthentication(event.context);
  //   }
  //
  //   if (event is LoginEvent) {
  //     yield* _login(event.params);
  //   }
  //
  //   if (event is Logout) {
  //     yield* _logout();
  //   }
  // }

  void _getAuthentication(AuthEvent event, Emitter<AuthState> emit) async {
    String? accessToken = await GetPreferences().getStoredAccessToken();
    int? membershipLevel = await GetPreferences().getStoredMembershipLevel();
    List<int> membershipList = [2,3,4,5,6,7];

    if (accessToken == null) {
      // yield const Unauthenticated();
      emit(const Unauthenticated());
    }
    else {
      // //TODO: REFACTOR THIS. USE THE ENUM MEMBERSHIP LEVEL IN CORE>UTILS FOLDER
      // DateTime? expiryDate = Jwt.getExpiryDate(accessToken.toString());
      // final DateTime now = DateTime.now().subtract(const Duration(hours: 8));
      //
      // if(expiryDate!.compareTo(now) > 0){
      //   // TODO Logout app
      //   yield* _logout();
      // } else {
      //   if (membershipList.contains(membershipLevel)) {
      //     yield const CommunityOfficerAuthenticated();
      //   } else {
      //     yield const MemberAuthenticated();
      //   }
      // }

      if (membershipList.contains(membershipLevel)) {
        // yield const CommunityOfficerAuthenticated();
        emit(const CommunityOfficerAuthenticated());
      } else {
        // yield const MemberAuthenticated();
        emit(const MemberAuthenticated());
      }
    }
  }

  void _login(LoginEvent event, Emitter<AuthState> emit) async {
    final dataState = await _getAuthUseCase(params: event.params);
    try{
      var logger = Logger();

      String? accessToken = dataState.data?.authResult!.accessToken;
      List<String?> permissionList = dataState.data!.permissions!;

    CurrentUserPermissions.listPermissions = permissionList;
    logger.i(permissionList);

      int? userId = dataState.data?.authResult!.userId;

      if (accessToken == null && userId == null) {
        // yield const Unauthenticated();
        emit(const Unauthenticated());
      } else {
        StorePreferences().storeAccessToken(accessToken!);
        StorePreferences().storeUserId(userId!);

        final String header = "Bearer $accessToken";
        final currentUserDataState = await _getCurrentUserUseCase(params: CurrentUserParams(header: header, userId: userId));

        final currentUserBox = Hive.box('currentUser');

        if (currentUserDataState.data != null) {
          final data = currentUserDataState.data!;
          String imageFileToken = data.imageFileToken!;
          int? membershipLevel = data.membershipLevel;

        List<int> membershipList = [2,3,4,5,6,7];
        logger.i('Contain in the list: '+ membershipList.contains(membershipLevel).toString());
        logger.i('MembershipLevel ID: '+ membershipLevel.toString());

        final profilePictureData = await _getCurrentUserProfilePictureUseCase(params: CurrentUserProfilePictureParams(imageTokenId: imageFileToken));

        ///TODO: REFACTOR THIS TO GET FROM ENUM MEMBERSHIP LEVEL

        // bool isOfficer = await GetPreferences().getIsOfficer();
        ///IF LOGGED-IN IS COMMUNITY OFFICER
        if (membershipLevel != null && membershipList.contains(membershipLevel)) {
          StorePreferences().storeMembershipLevel(membershipLevel);

            CurrentUser currentUser = CurrentUser(
                name: data.name,
                profilepicture: profilePictureData.data == null ? null : profilePictureData.data!.fileToken,
                barangay: data.barangay,
                purok: data.purok,
                mobileNumber: data.mobileNumber,
                imageFileToken: data.imageFileToken,
                memberId: data.memberId,
                idNumber: data.idNumber,
                birthdate: DateTime.parse(data.birthDate!),
                membershipLevel: data.membershipLevel,
                assignedOfficer: data.assignedOfficer);

            currentUserBox.add(currentUser);
            // yield const CommunityOfficerAuthenticated();
          emit(const CommunityOfficerAuthenticated());
          }

          ///IF LOGGED-IN IS NOT A COMMUNITY OFFICER
          else {
            StorePreferences().storeMembershipLevel(membershipLevel!);

            CurrentUser currentUser = CurrentUser(
                name: data.name,
                profilepicture: profilePictureData.data == null ? null : profilePictureData.data!.fileToken,
                barangay: data.barangay,
                purok: data.purok,
                mobileNumber: data.mobileNumber,
                imageFileToken: data.imageFileToken,
                memberId: data.memberId,
                idNumber: data.idNumber,
                birthdate: DateTime.parse(data.birthDate!),
                membershipLevel: data.membershipLevel,
                assignedOfficer: data.assignedOfficer);

            currentUserBox.add(currentUser);
            // yield const MemberAuthenticated();
          emit(const MemberAuthenticated());
          }
        } else {
          ///IF USER LOGGING IN IS ADMIN
          if (userId == 3) {
            CurrentUser currentUser = CurrentUser(
                name: 'Admin',
                profilepicture: null,
                barangay: null,
                purok: null,
                mobileNumber: null,
                imageFileToken: null,
                memberId: null,
                idNumber: null,
                birthdate: null,
                membershipLevel: null,
                assignedOfficer: null);

            currentUserBox.add(currentUser);
            // yield const MemberAuthenticated();
            emit(const MemberAuthenticated());
          } else {
            // yield const Unauthenticated();
            emit(const Unauthenticated());
          }
        }
        isLoading = false;
      }
      if(dataState is DataFailed){
        // yield AuthError(dataState.error as DioError);
        emit(AuthError(dataState.error as DioError));
      }
    }catch(_){
      isLoading = false;
      // yield AuthError(dataState.error as DioError);
      emit(AuthError(dataState.error as DioError));
    }
  }

  void _logout(Logout event, Emitter<AuthState> emit) async {
    await DeletePreferences().deleteAccessToken();
    // yield const Unauthenticated();
    emit(const Unauthenticated());
  }
}
