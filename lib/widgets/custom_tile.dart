import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lotosui/widgets/snackbar_tile.dart';

// ignore: must_be_immutable
class CustomTile<T> extends StatelessWidget {
  CustomTile({
    Key? key,
    required this.data,
    required this.icon,
    required this.label,
    required this.text,
    required this.trailing,
    required this.callback,
    this.padding = const EdgeInsets.only(left: 0, right: 0, top: 5),
  }) : super(key: key);

  final T data;
  final Icon icon;
  final String label;
  final String text;
  final Widget trailing;
  final EdgeInsetsGeometry padding;
  final Function(T) callback;

  late double screenWidth;
  final FToast ftoast = FToast();

  @override
  Widget build(BuildContext context) {
    ftoast.init(context);

    return Padding(
      padding: padding,
      child: Align(
        alignment: Alignment.center,
        child: InkWell(
          onTap: () => callback(data),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Slidable(
              closeOnScroll: true,
              endActionPane: endActionPane(),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: buildTile(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ActionPane endActionPane() {
    return ActionPane(
      motion: const DrawerMotion(),
      children: [
        SlidableAction(
          onPressed: (context) {
            showToast(
              context,
              ftoast: ftoast,
              text: "Функция в разработке\nSlidable delete is clicked!",
            );
          },
          backgroundColor: Colors.red,
          borderRadius: BorderRadius.circular(10),
          icon: Icons.delete_outline_rounded,
          label: "Удалить",
        ),
      ],
    );
  }

  buildTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 10, top: 10, bottom: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          Expanded(child: buildLabels(context)),
          trailing,
        ],
      ),
    );
  }

  Padding buildLabels(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
            softWrap: true,
          ),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
            softWrap: true,
          )
        ],
      ),
    );
  }
}
