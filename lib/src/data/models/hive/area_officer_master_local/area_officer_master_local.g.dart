// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_officer_master_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AreaOfficerMasterLocalAdapter
    extends TypeAdapter<AreaOfficerMasterLocal> {
  @override
  final int typeId = 9;

  @override
  AreaOfficerMasterLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AreaOfficerMasterLocal(
      amount: fields[0] as String?,
      referenceNumber: fields[1] as String?,
      communityOfficeId: fields[2] as String?,
      communityOfficerName: fields[3] as String?,
      communityOfficerMemberId: fields[4] as String?,
      memberRemittanceMasterID: fields[5] as String?,
      status: fields[6] as int?,
      isAreaOfficer: fields[7] as bool,
      agentMemberId: fields[8] as String?,
      agentMemberIdNumber: fields[9] as String?,
      creatorID: fields[10] as String?,
      dateCreated: fields[11] as String,
      transactionType: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AreaOfficerMasterLocal obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.referenceNumber)
      ..writeByte(2)
      ..write(obj.communityOfficeId)
      ..writeByte(3)
      ..write(obj.communityOfficerName)
      ..writeByte(4)
      ..write(obj.communityOfficerMemberId)
      ..writeByte(5)
      ..write(obj.memberRemittanceMasterID)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.isAreaOfficer)
      ..writeByte(8)
      ..write(obj.agentMemberId)
      ..writeByte(9)
      ..write(obj.agentMemberIdNumber)
      ..writeByte(10)
      ..write(obj.creatorID)
      ..writeByte(11)
      ..write(obj.dateCreated)
      ..writeByte(12)
      ..write(obj.transactionType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AreaOfficerMasterLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
