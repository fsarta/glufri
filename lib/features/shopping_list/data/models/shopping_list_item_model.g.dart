// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShoppingListItemModelAdapter extends TypeAdapter<ShoppingListItemModel> {
  @override
  final int typeId = 4;

  @override
  ShoppingListItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShoppingListItemModel(
      id: fields[0] as String,
      name: fields[1] as String,
      quantity: fields[2] as double,
      isChecked: fields[3] as bool,
      isGlutenFree: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ShoppingListItemModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.isChecked)
      ..writeByte(4)
      ..write(obj.isGlutenFree);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingListItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
