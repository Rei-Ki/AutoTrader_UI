import 'package:hive/hive.dart';
import 'instruments_hive.dart';

Future<void> saveToCache(List<String> data, String path) async {
  var box = await Hive.openBox<CachedInstrumentsData>(path);
  await box.put(0, CachedInstrumentsData(data));
  await box.close();
}

Future<List<String>> getFromCache(String path) async {
  var box = await Hive.openBox<CachedInstrumentsData>(path);
  var cachedData = box.get(0)?.instruments ?? [];
  await box.close();
  return cachedData;
}
