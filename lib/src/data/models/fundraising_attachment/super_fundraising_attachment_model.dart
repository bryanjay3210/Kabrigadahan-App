import 'package:kabrigadan_mobile/src/data/models/fundraising_attachment/fundraising_attachment/fundraising_attachment_model.dart';

class SuperFundraisingAttachmentModel{
  final FundraisingAttachmentModel? fundraisingAttachment;

  SuperFundraisingAttachmentModel({this.fundraisingAttachment});

  // const SuperFundraisingAttachmentModel({fundraisingAttachment}) : super(fundraisingAttachment);

  factory SuperFundraisingAttachmentModel.fromJson(Map<String, dynamic> json){
    return SuperFundraisingAttachmentModel(
      fundraisingAttachment: FundraisingAttachmentModel.fromJson(json['result'])
    );
  }
}