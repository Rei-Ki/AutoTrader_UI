import 'package:lotosui/bloc/data_classes.dart';

getSearchingData(search, allList) async {
  List<Pulse> searchedList = [];

  // filtering of string
  allList.forEach((instrument) {
    String title = instrument.title.toLowerCase();
    if (title.contains(search.toLowerCase())) {
      searchedList.add(instrument);
    }
  });

  return searchedList;
}
