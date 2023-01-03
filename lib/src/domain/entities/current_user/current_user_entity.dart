import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'current_user_entity.g.dart';
//ignore: must_be_immutable
@JsonSerializable()
class CurrentUserEntity extends Equatable {
  String? name;
  String? barangay;
  String? purok;
  String? mobileNumber;
  String? imageFileToken;
  String? memberId;
  String? idNumber;
  String? birthDate;
  int? membershipLevel;
  String? assignedOfficer;
  String? cityQrCodeId;

  CurrentUserEntity(this.name, this.barangay, this.purok, this.mobileNumber, this.imageFileToken, this.memberId, this.idNumber, this.birthDate, this.membershipLevel, this.assignedOfficer, this.cityQrCodeId);

  @override
  List<Object?> get props => [name, barangay, purok, mobileNumber, imageFileToken, memberId, idNumber, birthDate, membershipLevel, assignedOfficer, cityQrCodeId];

  @override
  bool? get stringify => true;

  factory CurrentUserEntity.fromJson(Map<String, dynamic> json) => _$CurrentUserEntityFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentUserEntityToJson(this);
}
