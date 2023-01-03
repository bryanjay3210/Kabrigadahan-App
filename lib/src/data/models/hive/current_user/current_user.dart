import 'package:hive/hive.dart';

part 'current_user.g.dart';

@HiveType(typeId: 0)
class CurrentUser {
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
  final DateTime? birthdate;

  @HiveField(9)
  final int? membershipLevel;

  @HiveField(10)
  final String? assignedOfficer;

  CurrentUser({this.name, this.profilepicture, this.barangay, this.purok, this.mobileNumber, this.imageFileToken, this.memberId, this.idNumber, this.birthdate, this.membershipLevel, this.assignedOfficer});
}
