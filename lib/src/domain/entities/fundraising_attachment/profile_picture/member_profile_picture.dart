import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member_profile_picture.g.dart';

@JsonSerializable()
class MemberProfilePicture extends Equatable{
  final String? fileToken;
  final String? fileType;
  final String? fileUrl;
  final bool? isPublic;

  const MemberProfilePicture(this.fileToken, this.fileType, this.fileUrl, this.isPublic);

  @override
  List<Object?> get props => [fileToken, fileType, fileUrl, isPublic];

  @override
  bool? get stringify => true;

  factory MemberProfilePicture.fromJson(Map<String, dynamic> json) => _$MemberProfilePictureFromJson(json);
  Map<String, dynamic> toJson() => _$MemberProfilePictureToJson(this);
}