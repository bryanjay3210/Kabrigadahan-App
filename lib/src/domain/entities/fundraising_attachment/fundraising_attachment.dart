import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising_attachment/fundraiser/fundraiser.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising_attachment/fundraising_attachment_details/fundraising_attachment_details.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising_attachment/photos/fundraising_attachment_photo.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising_attachment/profile_picture/member_profile_picture.dart';

part 'fundraising_attachment.g.dart';

@JsonSerializable()
class FundraisingAttachment extends Equatable{
  final List<FundraisingAttachmentPhoto>? photos;
  final Fundraiser? fundraiser;
  final MemberProfilePicture? memberProfilePicture;
  final FundraisingAttachmentDetails? fundraisingAttachmentDetails;

  const FundraisingAttachment(this.photos, this.fundraiser, this.memberProfilePicture, this.fundraisingAttachmentDetails);

  @override
  List<Object?> get props => [photos, fundraiser, memberProfilePicture, fundraisingAttachmentDetails];

  @override
  bool? get stringify => true;

  factory FundraisingAttachment.fromJson(Map<String, dynamic> json) => _$FundraisingAttachmentFromJson(json);
  Map<String, dynamic> toJson() => _$FundraisingAttachmentToJson(this);
}