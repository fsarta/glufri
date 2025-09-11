// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchaseItemModelAdapter extends TypeAdapter<PurchaseItemModel> {
  @override
  final int typeId = 1;

  @override
  PurchaseItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchaseItemModel(
      id: fields[0] as String,
      name: fields[1] as String,
      unitPrice: fields[2] as double,
      quantity: fields[3] as double,
      barcode: fields[4] as String?,
      imagePath: fields[5] as String?,
      isGlutenFree: fields[6] as bool,
      unitValue: fields[7] as double?,
      unitOfMeasure: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PurchaseItemModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.unitPrice)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.barcode)
      ..writeByte(5)
      ..write(obj.imagePath)
      ..writeByte(6)
      ..write(obj.isGlutenFree)
      ..writeByte(7)
      ..write(obj.unitValue)
      ..writeByte(8)
      ..write(obj.unitOfMeasure);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
