import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fundraising_attachment_photo.g.dart';

@JsonSerializable()
class FundraisingAttachmentPhoto extends Equatable{
  final String? fileToken;
  final String? fileUrl;

  const FundraisingAttachmentPhoto(this.fileToken, this.fileUrl);

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;

  factory FundraisingAttachmentPhoto.fromJson(Map<String, dynamic> json) => _$FundraisingAttachmentPhotoFromJson(json);
  Map<String, dynamic> toJson() => _$FundraisingAttachmentPhotoToJson(this);
}