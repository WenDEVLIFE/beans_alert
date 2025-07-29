import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;

  final String fontFamily;

  final FontWeight fontWeight;

  final double fontSize;

  final Color textColor;

  final VoidCallback onPressed;

  const CustomTextButton({
    Key? key,
    required this.text,
    required this.fontFamily,
    required this.fontWeight,
    required this.fontSize,
    required this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontFamily: fontFamily,
          fontSize:  fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}