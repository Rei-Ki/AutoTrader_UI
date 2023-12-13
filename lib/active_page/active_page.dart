import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/bloc/active_bloc.dart';
import 'package:lotosui/bloc/data_classes.dart';
import 'package:lotosui/widgets/search.dart';
import '../widgets/active_tile.dart';

class ActivePage extends StatefulWidget {
  const ActivePage({super.key});

  @override
  State<ActivePage> createState() => _ActivePageState();
}

class _ActivePageState extends State<ActivePage> {
  late List<Instrument> allInstruments;
  late BuildContext blocContext;

  // todo сделать корректное использование блока, каждый блок должен без
  //блок провайдера, а из контекста блок билдером браться
  // https://stackoverflow.com/questions/59633438/how-to-use-bloc-pattern-between-two-screens

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActiveBloc(),
      child: buildActiveBloc(),
    );
  }

  buildActiveBloc() {
    return BlocBuilder<ActiveBloc, ActiveState>(builder: (context, state) {
      if (state is ActiveInitialState) {
        blocContext = context;
        context.read<ActiveBloc>().add(GetActiveEvent());
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

  searchOnChange(value) {
    blocContext
        .read<ActiveBloc>()
        .add(ActiveSearchEvent(value, allInstruments));
  }
}
