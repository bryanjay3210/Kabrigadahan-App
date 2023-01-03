// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unremitted_donation_reference.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnremittedDonationReferenceAdapter
    extends TypeAdapter<UnremittedDonationReference> {
  @override
  final int typeId = 13;

  @override
  UnremittedDonationReference read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnremittedDonationReference(
      referenceNumber: fields[0] as String?,
      memberRemittanceMasterId: fields[1] as String?,
      transactionType: fields[2] as String?,
      collectorAgentId: fields[3] as String?,
      amount: fields[4] == null ? 0.0 : fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, UnremittedDonationReference obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.referenceNumber)
      ..writeByte(1)
      ..write(obj.memberRemittanceMasterId)
      ..writeByte(2)
      ..write(obj.transactionType)
      ..writeByte(3)
      ..write(obj.collectorAgentId)
      ..writeByte(4)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnremittedDonationReferenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
