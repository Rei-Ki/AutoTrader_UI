import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/bloc/data_classes.dart';
import 'package:flutter/material.dart';
import 'package:lotosui/bloc/pulse_bloc.dart';
import 'package:lotosui/widgets/search.dart';

class PulsePage extends StatefulWidget {
  const PulsePage({super.key});

  @override
  State<PulsePage> createState() => _PulsePageState();
}

class _PulsePageState extends State<PulsePage> {
  final TextEditingController searchedInstrumentsText = TextEditingController();
  List<Pulse> allPulses = [];
  late BuildContext pulseBlocContext;

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
        pulseBlocContext = context;
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

      return const Text("Maybe server is down");
    });
  }

  buildPulseList(List<Pulse> pulse) {
    return Column(
      children: [
        Search(
          textController: searchedInstrumentsText,
          onChange: searchOnChange,
        ),
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
    pulseBlocContext.read<PulseBloc>().add(
          PulseSearchEvent(value, allPulses),
        );
  }
}

// Плитка ------------------------------------
class PulseTile extends StatelessWidget {
  const PulseTile({
    super.key,
    required this.data,
  });

  final Pulse data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
        child: ListTile(
          leading: const Icon(Icons.notifications_active_outlined),
          title: Text(
            data.title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: Text(
            "Цена: ${data.price}\nКоличество: ${data.quantity}\nОперация: ${data.operation}",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          trailing: Text(data.date),
        ),
      ),
    );
  }
}
