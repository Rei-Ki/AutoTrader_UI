import 'package:flutter/material.dart';
import 'package:lotosui/bloc/data_classes.dart';

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

/*
import 'package:flutter/material.dart';
import 'package:lotosui/bloc/data_classes.dart';

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

 */
