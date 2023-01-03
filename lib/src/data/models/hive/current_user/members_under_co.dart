import 'package:hive/hive.dart';
part 'members_under_co.g.dart';

@HiveType(typeId: 4)
class MembersUnderCO {
  @HiveField(0)
  final String? name;

  @HiveField(1)
  final String? profilepicture;

  @HiveField(2)
  final String? barangay;

  @HiveField(3)
  final String? purok;

  @HiveField(4)
  final String? mobileNumber;

  @HiveField(5)
  final String? imageFileToken;

  @HiveField(6)
  final String? memberId;

  @HiveField(7)
  final String? idNumber;

  @HiveField(8)
  final String? birthDate;

  @HiveField(9)
  final int? membershipLevel;

  @HiveField(10)
  final String? assignedOfficer;

  @HiveField(11)
  final String? cityQrCodeId;


  MembersUnderCO({this.name, this.profilepicture, this.barangay, this.purok, this.mobileNumber, this.imageFileToken, this.memberId, this.idNumber, this.birthDate, this.membershipLevel, this.assignedOfficer, this.cityQrCodeId});

  factory MembersUnderCO.fromJson(Map<String, dynamic> json){
    return MembersUnderCO(
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
}