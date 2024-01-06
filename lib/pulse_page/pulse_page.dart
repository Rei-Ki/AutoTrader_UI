import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/bloc/data_classes.dart';
import 'package:flutter/material.dart';
import 'package:lotosui/bloc/pulse_bloc.dart';
import 'package:lotosui/widgets/search.dart';
import '../bloc/search_bloc.dart';
import '../widgets/pulse_tile.dart';

class PulsePage extends StatefulWidget {
  const PulsePage({super.key});

  @override
  State<PulsePage> createState() => _PulsePageState();
}

class _PulsePageState extends State<PulsePage> {
  late List<Pulse> allPulses;
  late PulseBloc pulseBloc;
  late SearchBloc<Pulse> searchBloc;

  @override
  void initState() {
    super.initState();

    searchBloc = SearchBloc<Pulse>();

    searchBloc.searchResultStream.listen((List<Pulse> result) {
      pulseBloc.add(UpdatePulseEvent(result));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PulseBloc()),
        BlocProvider.value(value: searchBloc),
      ],
      child: buildPulseBloc(),
    );
  }

  buildPulseBloc() {
    return BlocBuilder<PulseBloc, PulseState>(builder: (context, state) {
      if (state is PulseInitialState) {
        pulseBloc = context.read<PulseBloc>();
        context.read<PulseBloc>().add(GetPulseEvent());
      }

      if (state is PulseLoadingState) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is PulseLoadedState) {
        allPulses = state.pulses;
        return buildPulseList(allPulses);
      }

      if (state is UpdatePulseState) {
        return buildPulseList(state.data);
      }

      if (state is PulseErrorState) {
        return const Center(child: Text("Oops, Something went wrong"));
      }

      return Container();
    });
  }

  buildPulseList(List<Pulse> pulse) {
    return Column(
      children: [
        Search(onChange: searchOnChange),
        buildList(pulse),
      ],
    );
  }

  Expanded buildList(List<Pulse> pulse) {
    return Expanded(
      child: ListView.builder(
        itemCount: pulse.length,
        itemBuilder: (context, index) {
          return PulseTile(
            data: pulse[index],
          );
        },
      ),
    );
  }

  searchOnChange(value) {
    searchBloc.add(SearchingEvent(value, allPulses, Pulse));
  }
}
