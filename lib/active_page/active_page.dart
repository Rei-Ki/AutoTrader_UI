import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/bloc/active_bloc.dart';
import 'package:lotosui/bloc/data_classes.dart';
import 'package:lotosui/widgets/search.dart';
import '../bloc/search_bloc.dart';
import '../widgets/active_tile.dart';

class ActivePage extends StatefulWidget {
  const ActivePage({super.key});

  @override
  State<ActivePage> createState() => _ActivePageState();
}

class _ActivePageState extends State<ActivePage> {
  late List<Instrument> allInstruments;
  late ActiveBloc activeBloc;
  late SearchBloc<Instrument> searchBloc;
  List<String> selectedTags = [];

  @override
  void initState() {
    super.initState();

    searchBloc = SearchBloc<Instrument>();

    searchBloc.searchResultStream.listen((List<Instrument> result) {
      activeBloc.add(UpdateActiveEvent(result));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActiveBloc()),
        BlocProvider.value(value: searchBloc),
      ],
      child: buildActiveBloc(),
    );
  }

  buildActiveBloc() {
    return BlocBuilder<ActiveBloc, ActiveState>(builder: (context, state) {
      if (state is ActiveInitialState) {
        activeBloc = context.read<ActiveBloc>();
        context.read<ActiveBloc>().add(GetActiveEvent());
      }

      if (state is ActiveLoadingState) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is ActiveLoadedState) {
        allInstruments = state.instruments;
        return buildActiveList(allInstruments);
      }

      if (state is UpdateActiveState) {
        return buildActiveList(state.data);
      }

      if (state is ActiveErrorState) {
        return const Center(child: Text("Oops, Something went wrong (Active)"));
      }

      return Container();
    });
  }

  buildActiveList(List<Instrument> instruments) {
    return Column(
      children: [
        Search(
          onChange: searchOnChange,
          tags: activeBloc.allTags,
          callback: onSelectedTags,
        ),
        buildList(instruments),
      ],
    );
  }

  Expanded buildList(List<Instrument> instruments) {
    return Expanded(
      child: ListView.builder(
        itemCount: instruments.length,
        itemBuilder: (context, i) {
          return ActiveTile(
            data: instruments[i],
          );
        },
      ),
    );
  }

  onSelectedTags(List<String> tags) {
    selectedTags = tags;
    searchBloc.add(
      SearchingEvent(
        "",
        data: allInstruments,
        searchForType: Instrument,
        tags: selectedTags,
      ),
    );
  }

  searchOnChange(value) {
    searchBloc.add(
      SearchingEvent(
        value,
        data: allInstruments,
        searchForType: Instrument,
        tags: selectedTags,
      ),
    );
  }
}
