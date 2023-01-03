import 'package:equatable/equatable.dart';

class CurrentUserProfilePictureEntity extends Equatable {
  final String? fileToken;
  final String? fileType;

  const CurrentUserProfilePictureEntity(this.fileToken, this.fileType);

  @override
  List<Object?> get props => [fileToken, fileType];

  @override
  bool? get stringify => true;
}
