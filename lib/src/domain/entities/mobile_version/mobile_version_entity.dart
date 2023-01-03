import 'package:equatable/equatable.dart';

class MobileVersionEntity extends Equatable{
  final String? version;
  final String? versionNotes;
  final String? updateUrl;

  const MobileVersionEntity(this.version, this.versionNotes,this.updateUrl);

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}