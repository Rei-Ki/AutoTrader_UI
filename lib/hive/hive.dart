import 'package:hive/hive.dart';
import 'instruments_hive.dart';

Future<void> saveToCache(List<Map<String, dynamic>> data, String path) async {
  var box = await Hive.openBox<CachedInstrumentsData>(path);
  await box.put(0, CachedInstrumentsData(data));
  await box.close();
}

Future<List<Map<String, dynamic>>> getFromCache(String path) async {
  var box = await Hive.openBox<CachedInstrumentsData>(path);
  List<Map<String, dynamic>> cachedData =
      box.get(0)?.instruments ?? List<Map<String, dynamic>>.empty();
  await box.close();
  return cachedData;
}
