import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/bloc/data_classes.dart';
import 'package:flutter/material.dart';
import 'package:lotosui/pulse_page/pulse_bloc.dart';
import 'package:lotosui/widgets/custom_tile.dart';
import 'package:lotosui/widgets/search.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../bloc/search_bloc.dart';

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

  Expanded buildList(List<Pulse> pulse) {
    return Expanded(
      child: ListView.builder(
        itemCount: pulse.length,
        itemBuilder: (context, index) {
          var isLong = pulse[index].operation == 'покупка';
          var color = isLong ? Colors.green : Colors.red;
          var icon = isLong
              ? Icons.keyboard_arrow_up_rounded
              : Icons.keyboard_arrow_down_rounded;

          return CustomTimeLineTile(
            operation: pulse[index].operation,
            isFirst: index == 0,
            isLast: index == pulse.length - 1,
            datetime: pulse[index].date,
            child: CustomTile<Pulse>(
              data: pulse[index],
              label: pulse[index].title,
              icon: Icon(icon, color: color, size: 40),
              padding: const EdgeInsets.only(left: 0, right: 5, top: 5),
              text:
                  "${pulse[index].operation}\nЦена: ${pulse[index].quantity}*${pulse[index].price}",
              trailing: const Icon(Icons.more_vert_rounded, size: 27),
              callback: onTileTap,
            ),
          );
        },
      ),
    );
  }

  onTileTap(Pulse data) {
    print("pulse onTileTap");
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
  final String datetime;
  final Widget child;

  const CustomTimeLineTile({
    Key? key,
    required this.isFirst,
    required this.isLast,
    this.opacity = 0.55,
    required this.operation,
    required this.datetime,
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
        thickness: 3,
        color: Theme.of(context).primaryColor.withOpacity(opacity),
      ),
      endChild: child,
      indicatorStyle: IndicatorStyle(
        indicator: createIndicator(datetime),
        color: color.withOpacity(opacity),
        drawGap: true,
        width: 45,
        height: 35,
        padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
        iconStyle: IconStyle(iconData: icon),
      ),
    );
  }

  createIndicator(String text) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
