import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class FundraisingAttachmentMember extends Equatable{
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? mobileNumber;
  final String? address;
  final bool? isEmployed;
  final String? emergencyName;
  final String? emergencyMobileNumber;
  final String? idNumber;
  final int? gender;

  const FundraisingAttachmentMember(this.firstName, this.middleName, this.lastName, this.mobileNumber, this.address, this.isEmployed, this.emergencyName, this.emergencyMobileNumber, this.idNumber, this.gender);

  @override
  List<Object?> get props => [firstName, middleName, lastName, mobileNumber, address, isEmployed, emergencyName, emergencyMobileNumber, idNumber];

  @override
  bool? get stringify => true;

  factory FundraisingAttachmentMember.fromJson(Map<String, dynamic> json) => _$FundraisingAttachmentMemberFromJson(json);
  Map<String, dynamic> toJson() => _$FundraisingAttachmentMemberToJson(this);
}