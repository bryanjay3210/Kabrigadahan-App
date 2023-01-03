import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising_attachment/fundraiser/member/member.dart';

part 'fundraiser.g.dart';

@JsonSerializable()
class Fundraiser extends Equatable{
  final FundraisingAttachmentMember? member;
  final String? barangayName;
  final String? purokName;
  final String? religionName;
  final String? userName;

  const Fundraiser(this.member, this.barangayName, this.purokName, this.religionName, this.userName);

  @override
  List<Object?> get props => [member, barangayName, purokName, religionName, userName];

  @override
  bool? get stringify => true;

  factory Fundraiser.fromJson(Map<String, dynamic> json) => _$FundraiserFromJson(json);
  Map<String, dynamic> toJson() => _$FundraiserToJson(this);
}