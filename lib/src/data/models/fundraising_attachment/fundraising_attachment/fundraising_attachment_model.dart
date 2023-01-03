import 'package:kabrigadan_mobile/src/data/models/fundraising_attachment/fundraising_attachment/fundraiser_model/fundraiser_model.dart';
import 'package:kabrigadan_mobile/src/data/models/fundraising_attachment/fundraising_attachment/fundraising_attachment_details_model/fundraising_attachment_details_model.dart';
import 'package:kabrigadan_mobile/src/data/models/fundraising_attachment/fundraising_attachment/photos_model/photos_model.dart';
import 'package:kabrigadan_mobile/src/data/models/fundraising_attachment/fundraising_attachment/profile_picture_model/profile_picture_model.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising_attachment/fundraising_attachment.dart';

class FundraisingAttachmentModel extends FundraisingAttachment {
  const FundraisingAttachmentModel({photos, fundraiser, memberProfilePicture, fundraisingAttachmentDetails}) : super(photos, fundraiser, memberProfilePicture, fundraisingAttachmentDetails);

  factory FundraisingAttachmentModel.fromJson(Map<String, dynamic> json){
    return FundraisingAttachmentModel(
      photos: List<FundraisingAttachmentPhotosModel>.from(
        (json['photos'] as List<dynamic>).map((e) => FundraisingAttachmentPhotosModel.fromJson(e as Map<String, dynamic>))
      ),
      fundraiser: FundraiserModel.fromJson(json['fundraiser']),
      memberProfilePicture: FundraisingAttachmentProfilePictureModel.fromJson(json['profilePicture']),
      fundraisingAttachmentDetails: FundraisingAttachmentDetailsModel.fromJson(json['fundraisingDetails'])
    );
  }
}
