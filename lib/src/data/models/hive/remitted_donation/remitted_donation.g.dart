// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remitted_donation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RemittedDonationAdapter extends TypeAdapter<RemittedDonation> {
  @override
  final int typeId = 3;

  @override
  RemittedDonation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RemittedDonation(
      caseCode: fields[0] as String?,
      amount: fields[1] as double?,
      donatedByMemberIdNumber: fields[2] as String?,
      agentMemberIdNumber: fields[3] as String?,
      status: fields[4] as int?,
      memberRemittanceMasterId: fields[5] as String?,
      ayannahAttachment: fields[6] as String?,
      unremittedTempId: fields[7] as String?,
      id: fields[8] as String?,
      name: fields[9] as String?,
      dateRecorded: fields[10] as DateTime?,
      creatorId: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RemittedDonation obj) {
    writer
      ..writeByte(12)
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
      ..write(obj.name)
      ..writeByte(10)
      ..write(obj.dateRecorded)
      ..writeByte(11)
      ..write(obj.creatorId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemittedDonationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
