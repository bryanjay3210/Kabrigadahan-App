import 'package:equatable/equatable.dart';
import 'package:kabrigadan_mobile/src/domain/entities/fundraising_attachment/fundraising_attachment.dart';

class SuperFundraisingAttachment extends Equatable{
  final FundraisingAttachment? fundraisingAttachment;

  const SuperFundraisingAttachment(this.fundraisingAttachment);

  @override
  List<Object?> get props => [fundraisingAttachment];

  @override
  bool? get stringify => true;
}