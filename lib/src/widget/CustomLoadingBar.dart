import 'package:flutter/material.dart';

class CustomLoadingBar extends StatelessWidget {
  final Color color;
  final double height;
  final String? label;
  final double progress;

  const CustomLoadingBar({
    Key? key,
    this.color = Colors.black,
    this.height = 20.0, // Make it bigger
    this.label,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(30.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              label!,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: color.withOpacity(0.2),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: SizedBox(
              height: height,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ),
      ],
    );
  }
}