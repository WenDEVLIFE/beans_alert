import 'package:beans_alert/src/helpers/ColorHelpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String hintText;
  final String fontFamily;
  final double fontSize;
  final FontWeight fontWeight;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const CustomButton({
    Key? key,
    required this.hintText,
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
    required this.onPressed,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorHelpers.accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          hintText,
          style: TextStyle(
            color: Colors.white,
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}