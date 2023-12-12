import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/bloc/data_classes.dart';
import 'package:flutter/material.dart';
import 'package:lotosui/bloc/pulse_bloc.dart';
import 'package:lotosui/widgets/search.dart';
import '../widgets/pulse_tile.dart';

class PulsePage extends StatefulWidget {
  const PulsePage({super.key});

  @override
  State<PulsePage> createState() => _PulsePageState();
}

class _PulsePageState extends State<PulsePage> {
  List<Pulse> allPulses = [];
  late BuildContext blocContext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PulseBloc(),
      child: buildPulseBloc(),
    );
  }

  buildPulseBloc() {
    return BlocBuilder<PulseBloc, PulseState>(builder: (context, state) {
      if (state is PulseInitialState) {
        blocContext = context;
        context.read<PulseBloc>().add(GetPulseEvent());
      }

      if (state is PulseLoadingState) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is PulseLoadedState) {
        allPulses = state.pulses;
        return buildPulseList(allPulses);
      }

      if (state is PulseErrorState) {
        return const Center(child: Text("Oops, Something went wrong"));
      }

      if (state is PulseSearchingState) {
        List<Pulse> searched = state.searched;
        return buildPulseList(searched);
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

  searchOnChange(value) {
    blocContext.read<PulseBloc>().add(PulseSearchEvent(value, allPulses));
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
}

/*
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/bloc/data_classes.dart';
import 'package:flutter/material.dart';
import 'package:lotosui/widgets/search.dart';
import '../bloc/bloc.dart';
import '../bloc/events.dart';
import '../bloc/states.dart';
import '../widgets/pulse_tile.dart';

class PulsePage extends StatefulWidget {
  const PulsePage({super.key});

  @override
  State<PulsePage> createState() => _PulsePageState();
}

class _PulsePageState extends State<PulsePage> {
  List<Pulse> allPulses = [];
  late BuildContext blocContext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(),
      child: buildPulseBloc(),
    );
  }

  buildPulseBloc() {
    return BlocBuilder<MainBloc, MainState>(builder: (context, state) {
      if (state is InitialState) {
        blocContext = context;
        context.read<MainBloc>().add(GetPulseEvent());
      }

      if (state is PulseLoadingState) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is PulseLoadedState) {
        allPulses = state.pulses;
        return buildPulseList(allPulses);
      }

      if (state is ErrorState) {
        return const Center(child: Text("Oops, Something went wrong"));
      }

      if (state is PulseSearchingState) {
        List<Pulse> searched = state.searched;
        return buildPulseList(searched);
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

  searchOnChange(value) {
    blocContext.read<MainBloc>().add(PulseSearchEvent(value, allPulses));
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
}

 */
