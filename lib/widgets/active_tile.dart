import 'package:flutter/material.dart';
import 'package:lotosui/bloc/data_classes.dart';

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
