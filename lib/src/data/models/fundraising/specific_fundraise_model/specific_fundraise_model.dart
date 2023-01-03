import 'package:kabrigadan_mobile/src/domain/entities/fundraising/specific_fundraising.dart';

class SpecificFundraiseModel extends SpecificFundraising{
  const SpecificFundraiseModel({
    dateFiled,
    dependent,
    verifierRemarks,
    caseDescription,
    diagnosis,
    inNeedOf,
    reason,
    fundraiser,
    approvedBy,
    communityOfficer,
    caseVerifiedBy,
    amount,
    caseCode,
    status,
    startDate,
    endDate,
    recipient,
    id
  }) : super(
      dateFiled,
      dependent,
      verifierRemarks,
      caseDescription,
      diagnosis,
      inNeedOf,
      reason,
      fundraiser,
      approvedBy,
      communityOfficer,
      caseVerifiedBy,
      amount,
      caseCode,
      status,
      startDate,
      endDate,
      recipient,
      id
  );

  factory SpecificFundraiseModel.fromJson(Map<String, dynamic> map) {
    return SpecificFundraiseModel(
        dateFiled: map['dateFiled'] as String?,
        dependent: map['dependent'] as bool?,
        verifierRemarks: map['verifierRemarks'] as String?,
        caseDescription: map['caseDescription'] as String?,
        diagnosis: map['diagnosis'] as String?,
        inNeedOf: map['inNeedOf'] as String?,
        reason: map['reason'] as int?,
        fundraiser: map['fundraiser'] as String?,
        approvedBy: map['approvedBy'] as String?,
        communityOfficer: map['communityOfficer'] as String?,
        caseVerifiedBy: map['caseVerifiedBy'] as String?,
        amount: map['amount'] as double?,
        caseCode: map['caseCode'] as String?,
        status: map['status'] as int?,
        startDate: map['startDate'] as String?,
        endDate: map['endDate'] as String?,
        recipient: map['recipient'] as String?,
        id: map['id'] as String?,
    );
  }
}