import 'package:flutter/material.dart';
import 'package:lotosui/bloc/data_classes.dart';

class PulseTile extends StatelessWidget {
  const PulseTile({
    super.key,
    required this.data,
  });

  final Pulse data;

  // todo написать свою плитку, а не использовать ListTile

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            "${data.operation} | Цена: ${data.quantity}*${data.price}",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          trailing: Text(data.date),
        ),
      ),
    );
  }
}
