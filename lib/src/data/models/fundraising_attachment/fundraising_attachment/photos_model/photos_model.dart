import 'package:kabrigadan_mobile/src/domain/entities/fundraising_attachment/photos/fundraising_attachment_photo.dart';

class FundraisingAttachmentPhotosModel extends FundraisingAttachmentPhoto{
  const FundraisingAttachmentPhotosModel({fileToken, fileUrl}) : super(fileToken, fileUrl);

  factory FundraisingAttachmentPhotosModel.fromJson(Map<String, dynamic> json){
    return FundraisingAttachmentPhotosModel(
      fileToken: json['fileToken'] as String?,
      fileUrl: json['fileUrl'] as String?
    );
  }
}