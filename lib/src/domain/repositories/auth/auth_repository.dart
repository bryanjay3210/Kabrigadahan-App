import 'package:kabrigadan_mobile/src/core/params/auth/auth_params.dart';
import 'package:kabrigadan_mobile/src/core/resources/data_state.dart';
import 'package:kabrigadan_mobile/src/domain/entities/auth/auth_entity.dart';

abstract class AuthRepository{
  ///API FOR TOKEN AUTH
  Future<DataState<AuthEntity>> tokenAuth(AuthParams? params);
}