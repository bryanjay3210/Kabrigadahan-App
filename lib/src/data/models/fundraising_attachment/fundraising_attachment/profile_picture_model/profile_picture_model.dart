import 'package:kabrigadan_mobile/src/domain/entities/fundraising_attachment/profile_picture/member_profile_picture.dart';

class FundraisingAttachmentProfilePictureModel extends MemberProfilePicture{
  const FundraisingAttachmentProfilePictureModel({fileToken, fileType, fileUrl, isPublic}) : super(fileToken, fileType, fileUrl, isPublic);

  factory FundraisingAttachmentProfilePictureModel.fromJson(Map<String, dynamic> json){
    return FundraisingAttachmentProfilePictureModel(
      fileToken: json['fileToken'] as String?,
      fileType: json['fileType'] as String?,
      fileUrl: json['fileUrl'] as String?,
      isPublic: json['isPublic'] as bool?
    );
  }
}