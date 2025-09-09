import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  final double diameter;
  final Color color;
  final Widget? child;

  const CircleWidget({
    Key? key,
    required this.diameter,
    this.color = Colors.blue,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(child: child),
    );
  }
}

