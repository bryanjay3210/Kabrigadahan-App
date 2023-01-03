import 'package:kabrigadan_mobile/src/domain/entities/current_user/current_user_entity.dart';

//ignore: must_be_immutable
class CurrentUserModel extends CurrentUserEntity {
  CurrentUserModel({name, barangay, purok, mobileNumber, imageFileToken, memberId, idNumber, birthDate, membershipLevel, assignedOfficer, cityQrCodeId})
      : super(name, barangay, purok, mobileNumber, imageFileToken, memberId, idNumber, birthDate, membershipLevel, assignedOfficer, cityQrCodeId);

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) {
    return CurrentUserModel(
      name: json['name'] as String?,
      barangay: json['barangay'] as String?,
      purok: json['purok'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      imageFileToken: json['imageFileToken'] as String?,
      memberId: json['memberId'] as String?,
      idNumber: json['idNumber'] as String?,
      birthDate: json['birthDate'] as String?,
      membershipLevel: json['membershipLevel'] as int?,
      assignedOfficer: json['assignedOfficer'] as String?
    );
  }
}
