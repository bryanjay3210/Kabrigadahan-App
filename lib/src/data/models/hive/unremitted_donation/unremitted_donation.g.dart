// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unremitted_donation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnremittedDonationAdapter extends TypeAdapter<UnremittedDonation> {
  @override
  final int typeId = 1;

  @override
  UnremittedDonation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnremittedDonation(
      caseCode: fields[0] as String?,
      amount: fields[1] as double?,
      donatedByMemberIdNumber: fields[2] as String?,
      agentMemberIdNumber: fields[3] as String?,
      status: fields[4] as int?,
      memberRemittanceMasterId: fields[5] as String?,
      ayannahAttachment: fields[6] as String?,
      unremittedTempId: fields[7] as String?,
      id: fields[8] as String?,
      creatorId: fields[9] as String?,
      referenceNumber: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UnremittedDonation obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.caseCode)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.donatedByMemberIdNumber)
      ..writeByte(3)
      ..write(obj.agentMemberIdNumber)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.memberRemittanceMasterId)
      ..writeByte(6)
      ..write(obj.ayannahAttachment)
      ..writeByte(7)
      ..write(obj.unremittedTempId)
      ..writeByte(8)
      ..write(obj.id)
      ..writeByte(9)
      ..write(obj.creatorId)
      ..writeByte(10)
      ..write(obj.referenceNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnremittedDonationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
