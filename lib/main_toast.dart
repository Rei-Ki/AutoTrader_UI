import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: FrostedDemo()));
}

class FrostedDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: FlutterLogo(),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
          ),
        ),
      ],
    );
  }
}
