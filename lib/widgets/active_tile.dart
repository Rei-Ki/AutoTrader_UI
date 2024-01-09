import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lotosui/bloc/data_classes.dart';

class ActiveTile extends StatelessWidget {
  const ActiveTile({
    super.key,
    required this.data,
    required this.icon,
    required this.label,
    required this.text,
    required this.trailing,
  });

  final Instrument data;
  final IconData icon;
  final String label;
  final String text;
  final Widget trailing;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                debugPrint("Slidable delete is clicked!");
              },
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(10),
              icon: Icons.delete_outline_rounded,
              label: "Удалить",
            ),
          ],
        ),
        // Child -----------------------------------------------------
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: buildTile(context),
        ),
      ),
    );
  }

  buildTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 27),
              buildLabels()
            ],
          ),
          trailing,
        ],
      ),
    );
  }

  Padding buildLabels() {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20, 
              fontWeight: FontWeight.w500, 
              letterSpacing: 0.8, 
            ) 
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15, 
              fontWeight: FontWeight.w300,  
            ) 
          )
        ]
      ),
    );
  }
}
    
    // ListTile(
    //   leading: const Icon(icon),
    //   trailing: const Icon(Icons.more_vert_rounded, size: 27),
    //   title: Text(
    //     data.title,
    //     style: Theme.of(context).textTheme.bodyMedium,
    //   ),
    //   subtitle: Text(
    //     "Тип: ${data.type}",
    //     style: Theme.of(context).textTheme.labelSmall,
    //   ),
    //   // Events -----------------------------------------------
    //   onTap: () {
    //     Navigator.of(context).pushNamed(
    //       '/instrumentInfo',
    //       arguments: data.title,
    //     );
    //   },
    // );

