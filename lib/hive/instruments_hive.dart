import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class CachedInstrumentsData extends HiveObject {
  // path = "instruments";
  @HiveField(0)
  List<Map<String, dynamic>> instruments;
  // String instruments;

  CachedInstrumentsData(this.instruments);
}

class CachedInstrumentsDataAdapter extends TypeAdapter<CachedInstrumentsData> {
  @override
  final typeId = 0;

  @override
  CachedInstrumentsData read(BinaryReader reader) {
    final length = reader.readInt();
    final instruments = <Map<String, dynamic>>[];
    for (var i = 0; i < length; i++) {
      final map = <String, dynamic>{};
      final keyCount = reader.readInt();
      for (var j = 0; j < keyCount; j++) {
        final key = reader.readString();
        final value = reader.read(); // Assumes value can be of any type
        map[key] = value;
      }
      instruments.add(map);
    }
    return CachedInstrumentsData(instruments);
  }

  @override
  void write(BinaryWriter writer, CachedInstrumentsData obj) {
    writer.writeInt(obj.instruments.length);
    for (final map in obj.instruments) {
      writer.writeInt(map.length);
      for (final key in map.keys) {
        writer.writeString(key);
        writer.write(map[key]);
      }
    }
  }
  // @override
  // CachedInstrumentsData read(BinaryReader reader) {
  //   return CachedInstrumentsData(reader.read());
  // }

  // @override
  // void write(BinaryWriter writer, CachedInstrumentsData obj) {
  //   writer.write(obj.instruments);
  // }
}

// class CachedInstrumentsDataAdapter extends TypeAdapter<CachedInstrumentsData> {
//   // CachedInstrumentsDataAdapter(this.typeId);

//   @override
//   final int typeId = 0;

//   @override
//   CachedInstrumentsData read(BinaryReader reader) {
//     final instruments = reader.read() as List<Map<String, dynamic>>;

//     return CachedInstrumentsData(instruments);
//   }

//   @override
//   void write(BinaryWriter writer, CachedInstrumentsData obj) {
//     writer.write(obj.instruments);
//   }
// }
