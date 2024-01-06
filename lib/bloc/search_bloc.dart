import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc<T> extends Bloc<SearchEvent<T>, SearchState<T>> {
  final searchResultController = StreamController<List<T>>.broadcast();

  late List<T> resultSearchedList;
  SearchBloc() : super(SearchInitialState()) {
    on<SearchingEvent<T>>(onSearch);
  }

  void onSearch(SearchEvent<T> event, Emitter<SearchState<T>> emit) async {
    try {
      List<T> searchedList = [];
      Type searchForType = event.searchForType;
      String search = event.search;
      List<T> allData = event.data;

      // Ваш блок поиска
      allData.forEach((item) {
        if (item.runtimeType == searchForType) {
          String title = (item as dynamic).title.toLowerCase();
          if (title.contains(search.toLowerCase())) {
            searchedList.add(item);
          }
        }
      });

      resultSearchedList = searchedList;
    } catch (error) {
      resultSearchedList = [];
    }

    searchResultController.add(resultSearchedList);
  }

  Stream<List<T>> get searchResultStream => searchResultController.stream;

  Stream<SearchState<T>> mapEventToState(SearchEvent<T> event) async* {
    if (event is SearchingEvent<T>) {
      // ... остальной код
      searchResultController.add(resultSearchedList);
    }
  }

  @override
  Future<void> close() {
    searchResultController.close();
    return super.close();
  }
}

// States ------------------------------------
abstract class SearchState<T> {}

class SearchInitialState<T> extends SearchState<T> {}

class SearchingState<T> extends SearchState<T> {
  final List<T> searchedList;

  SearchingState(this.searchedList);
}

class SearchErrorState<T> extends SearchState<T> {}

// Events ------------------------------------
abstract class SearchEvent<T> {
  String get search;
  List<T> get data;
  Type get searchForType;
}

class SearchingEvent<T> extends SearchEvent<T> {
  @override
  final String search;
  @override
  final List<T> data;
  @override
  final Type searchForType;

  SearchingEvent(this.search, this.data, this.searchForType);
}
