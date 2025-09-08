// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteProductModelAdapter extends TypeAdapter<FavoriteProductModel> {
  @override
  final int typeId = 3;

  @override
  FavoriteProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteProductModel(
      id: fields[0] as String,
      name: fields[1] as String,
      barcode: fields[2] as String?,
      isGlutenFree: fields[3] as bool,
      defaultPrice: fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteProductModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.barcode)
      ..writeByte(3)
      ..write(obj.isGlutenFree)
      ..writeByte(4)
      ..write(obj.defaultPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
