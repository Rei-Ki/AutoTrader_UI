import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/bloc/bloc.dart';
import 'package:lotosui/bloc/data_classes.dart';
import 'package:lotosui/bloc/states.dart';
import 'package:lotosui/widgets/search.dart';
import '../bloc/events.dart';
import '../widgets/active_tile.dart';

class ActivePage extends StatefulWidget {
  const ActivePage({super.key});

  @override
  State<ActivePage> createState() => _ActivePageState();
}

class _ActivePageState extends State<ActivePage> {
  late List<Instrument> allInstruments;
  late BuildContext blocContext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(),
      child: buildActiveBloc(),
    );
  }

  buildActiveBloc() {
    return BlocBuilder<MainBloc, MainState>(builder: (context, state) {
      if (state is InitialState) {
        //ActiveInitialState
        blocContext = context;
        context.read<MainBloc>().add(GetActiveEvent());
      }

      if (state is ActiveLoadingState) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is ActiveLoadedState) {
        allInstruments = state.instruments;
        return buildActiveList(allInstruments);
      }

      if (state is ActiveSearchingState) {
        List<Instrument> searched = state.searched;
        return buildActiveList(searched);
      }

      if (state is ActiveErrorState) {
        return const Center(child: Text("Oops, Something went wrong"));
      }

      return Container();
    });
  }

  buildActiveList(List<Instrument> instruments) {
    return Column(
      children: [
        Search(onChange: searchOnChange),
        buildList(instruments),
      ],
    );
  }

  searchOnChange(value) {
    blocContext.read<MainBloc>().add(ActiveSearchEvent(value, allInstruments));
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
}
