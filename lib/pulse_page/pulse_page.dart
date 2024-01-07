import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/bloc/data_classes.dart';
import 'package:flutter/material.dart';
import 'package:lotosui/bloc/pulse_bloc.dart';
import 'package:lotosui/widgets/search.dart';
import 'package:timeline_tile/timeline_tile.dart';
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
  List<String> selectedTags = [];

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
        Search(
          onChange: searchOnChange,
          tags: pulseBloc.allTags,
          callback: onSelectedTags,
        ),
        buildList(pulse),
      ],
    );
  }

  // todo Сделать таймлайн
  //! Таймлайн

  Expanded buildList(List<Pulse> pulse) {
    return Expanded(
      child: ListView.builder(
        itemCount: pulse.length,
        itemBuilder: (context, index) {
          return CustomTimeLineTile(
            operation: pulse[index].operation,
            isFirst: index == 0,
            isLast: index == pulse.length - 1,
            child: PulseTile(
              data: pulse[index],
            ),
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
        data: allPulses,
        searchForType: Pulse,
        tags: selectedTags,
      ),
    );
  }

  searchOnChange(value) {
    searchBloc.add(
      SearchingEvent(
        value,
        data: allPulses,
        searchForType: Pulse,
        tags: selectedTags,
      ),
    );
  }
}

//! TimeLineTile
class CustomTimeLineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final double opacity;
  final String operation;
  final Widget child;

  const CustomTimeLineTile({
    Key? key,
    required this.isFirst,
    required this.isLast,
    this.opacity = 0.55,
    required this.operation,
    required this.child,
  }) : super(key: key);

  // todo сделать смену цвета если продажа (красный) или покупка (зеленый)

  @override
  Widget build(BuildContext context) {
    var isLong = operation == 'покупка';
    var color = isLong ? Colors.green : Colors.red;
    var icon = isLong
        ? Icons.keyboard_arrow_up_rounded
        : Icons.keyboard_arrow_down_rounded;

    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
        color: Theme.of(context).primaryColor.withOpacity(opacity),
      ),
      endChild: child,
      indicatorStyle: IndicatorStyle(
        color: color.withOpacity(opacity),
        drawGap: true,
        width: 30,
        padding: const EdgeInsets.all(8),
        iconStyle: IconStyle(iconData: icon),
      ),
    );
  }
}
