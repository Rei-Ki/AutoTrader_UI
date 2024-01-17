import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class CachedInstrumentsData extends HiveObject {
  // path = "instruments";
  @HiveField(0)
  List<String> instruments;

  CachedInstrumentsData(this.instruments);
}

class CachedInstrumentsDataAdapter extends TypeAdapter<CachedInstrumentsData> {
  @override
  final typeId = 0;

  @override
  CachedInstrumentsData read(BinaryReader reader) {
    return CachedInstrumentsData(reader.read());
  }

  @override
  void write(BinaryWriter writer, CachedInstrumentsData obj) {
    writer.write(obj.instruments);
  }
}
