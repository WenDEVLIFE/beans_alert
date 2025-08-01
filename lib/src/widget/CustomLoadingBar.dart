import 'package:flutter/material.dart';

class CustomLoadingBar extends StatelessWidget {
  final Color color;
  final double height;
  final String? label;
  final double progress; // Add this

  const CustomLoadingBar({
    Key? key,
    this.color = Colors.blue,
    this.height = 6.0,
    this.label,
    required this.progress, // Make this required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          child: LinearProgressIndicator(
            value: progress, // Set progress here
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              label!,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}