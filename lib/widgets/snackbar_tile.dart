import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

// TODO 1 Сделать ее как то меньше по нормальному

void showToast(
  BuildContext context, {
  required FToast ftoast,
  required String text,
}) {
  ftoast.showToast(
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 2),
    isDismissable: true,
    child: createToast(context, ftoast, text),
  );
}

Widget createToast(BuildContext context, FToast ftoast, String text) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10.0),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: getBoxDecoration(context),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                child: Text(
                  text,
                  textAlign: TextAlign.justify,
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// BoxDecoration getBoxDecoration(BuildContext context) {
//   return BoxDecoration(
//     color: Colors.white.withOpacity(0.5), // Adjust the color and opacity
//     borderRadius: BorderRadius.circular(10),
//   );
// }

BoxDecoration getBoxDecoration(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: Theme.of(context).primaryColor.withOpacity(0.6),
      width: 1.5,
    ),
    color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.35),
  );
}

removeToast({required FToast ftoast}) => ftoast.removeCustomToast();

removeAllQueuedToasts({required FToast ftoast}) =>
    ftoast.removeQueuedCustomToasts();
