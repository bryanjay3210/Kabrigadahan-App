import 'package:kabrigadan_mobile/src/domain/entities/fundraising_attachment/fundraiser/member/member.dart';

class FundraiserMemberModel extends FundraisingAttachmentMember {
  const FundraiserMemberModel({firstName, middleName, lastName, mobileNumber, address, isEmployed, emergencyName, emergencyMobileNumber, idNumber, gender})
  : super(
      firstName,
      middleName,
      lastName,
      mobileNumber,
      address,
      isEmployed,
      emergencyName,
      emergencyMobileNumber,
      idNumber,
      gender
  );

  factory FundraiserMemberModel.fromJson(Map<String, dynamic> json){
    return FundraiserMemberModel(
        firstName: json['firstName'] as String?,
        middleName: json['middleName'] as String?,
        lastName: json['lastName'] as String?,
        mobileNumber: json['mobileNumber'] as String?,
        address: json['address'] as String?,
        isEmployed: json['isEmployed'] as bool?,
        emergencyName: json['emergencyName'] as String?,
        emergencyMobileNumber: json['emergencyMobileNumber'] as String?,
        idNumber: json['idNumber'] as String?,
        gender: json['gender'] as int?
    );
  }
}
