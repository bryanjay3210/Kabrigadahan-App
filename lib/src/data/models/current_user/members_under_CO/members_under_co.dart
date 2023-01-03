import 'package:kabrigadan_mobile/src/domain/entities/current_user/current_user_entity.dart';

//ignore: must_be_immutable
class MembersUnderCOModel extends CurrentUserEntity {
  MembersUnderCOModel({name, barangay, purok, mobileNumber, imageFileToken, memberId, idNumber, birthDate, membershipLevel, assignedOfficer, cityQrCodeId})
      : super(name, barangay, purok, mobileNumber, imageFileToken, memberId, idNumber, birthDate, membershipLevel, assignedOfficer, cityQrCodeId);

  factory MembersUnderCOModel.fromJson(Map<String, dynamic> json) {
    return MembersUnderCOModel(
        name: json['name'] as String?,
        barangay: json['barangay'] as String?,
        purok: json['purok'] as String?,
        mobileNumber: json['mobileNumber'] as String?,
        imageFileToken: json['imageFileToken'] as String?,
        memberId: json['memberId'] as String?,
        idNumber: json['idNumber'] as String?,
        birthDate: json['birthDate'] as String?,
        membershipLevel: json['membershipLevel'] as int?,
        assignedOfficer: json['assignedOfficer'] as String?,
        cityQrCodeId: json['cityQrCodeId'] as String?
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "barangay": barangay,
    "purok": purok,
    "mobileNumber": mobileNumber,
    "imageFileToken": imageFileToken,
    "memberId": memberId,
    "idNumber": idNumber,
    "birthDate":birthDate,
    "membershipLevel": membershipLevel,
    "assignedOfficer": assignedOfficer,
    "cityQrCodeId": cityQrCodeId
  };
}
