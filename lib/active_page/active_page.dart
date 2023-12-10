import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/bloc/active_bloc.dart';
import 'package:lotosui/bloc/data_classes.dart';
import 'package:lotosui/widgets/search.dart';

class ActivePage extends StatefulWidget {
  const ActivePage({super.key});

  @override
  State<ActivePage> createState() => _ActivePageState();
}

class _ActivePageState extends State<ActivePage> {
  final TextEditingController searchedInstrumentsText = TextEditingController();
  late List<Instrument> allInstruments;
  late BuildContext actionBlocContext;

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
        actionBlocContext = context;
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
      return const Text("Maybe server is down");
    });
  }

  buildActiveList(List<Instrument> instruments) {
    return Column(
      children: [
        Search(
          textController: searchedInstrumentsText,
          onChange: searchOnChange,
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

  searchOnChange(value) {
    actionBlocContext.read<ActiveBloc>().add(
          ActiveSearchEvent(value, allInstruments),
        );
  }
}

// Плитка ------------------------------------
class ActiveTile extends StatelessWidget {
  const ActiveTile({
    super.key,
    required this.data,
  });

  final Instrument data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: const Icon(Icons.data_usage_rounded, size: 29),
          trailing: const Icon(Icons.more_vert_rounded, size: 27),
          title: Text(
            data.title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: Text(
            "Тип: ${data.type}",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              '/instrumentInfo',
              arguments: data.title,
            );
          },
        ),
      ),
    );
  }
}
