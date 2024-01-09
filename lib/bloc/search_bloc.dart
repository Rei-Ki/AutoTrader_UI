import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class SearchBloc<T> extends Bloc<SearchEvent<T>, SearchState<T>> {
  final searchResultController = StreamController<List<T>>.broadcast();

  late List<T> resultSearchedList;
  SearchBloc() : super(SearchInitialState()) {
    on<SearchingEvent<T>>(onSearch);
  }

  void onSearch(event, emit) async {
    try {
      Type searchForType = event.searchForType;
      String search = event.search;
      List<String> tags = event.tags;

      // Первый этап фильтрации: фильтрация по тегам
      List<T> tagSearch = searchTags(event.data, tags);

      // Второй этап фильтрации: фильтрация по списку
      List<T> stringSearch = searchString(tagSearch, search, searchForType);

      resultSearchedList = stringSearch;
    } catch (e, st) {
      resultSearchedList = [];
      GetIt.I<Talker>().handle(e, st);
    }

    searchResultController.add(resultSearchedList);
  }

  searchTags(List<T> data, tags) {
    if (tags.isEmpty) {
      return data;
    }

    List<T> filtered = [];
    data.forEach((item) {
      List<String> itemTags = (item as dynamic).tags;
      if (tags.every((tag) => itemTags.contains(tag))) {
        filtered.add(item);
      }
    });

    return filtered;
  }

  searchString(List<T> data, String search, Type searchForType) {
    if (search.isEmpty) {
      return data;
    }

    List<T> filtered = [];

    data.forEach((item) {
      if (item.runtimeType == searchForType) {
        String title = (item as dynamic).title.toLowerCase();
        if (title.contains(search.toLowerCase())) {
          filtered.add(item);
        }
      }
    });
    return filtered;
  }

  Stream<List<T>> get searchResultStream => searchResultController.stream;

  Stream<SearchState<T>> mapEventToState(SearchEvent<T> event) async* {
    if (event is SearchingEvent<T>) {
      searchResultController.add(resultSearchedList);
    }
  }

  @override
  Future<void> close() {
    searchResultController.close();
    return super.close();
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().error(error, stackTrace);
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
  List<String> get tags;
}

class SearchingEvent<T> extends SearchEvent<T> {
  @override
  final String search;
  @override
  final List<T> data;
  @override
  final Type searchForType;
  @override
  final List<String> tags;

  SearchingEvent(
    this.search, {
    required this.tags,
    required this.data,
    required this.searchForType,
  });
}
