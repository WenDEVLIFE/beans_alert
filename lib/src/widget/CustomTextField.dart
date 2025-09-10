import 'package:beans_alert/src/helpers/ColorHelpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color borderColor;
  final Color fillColor;
  final IconData? prefixIcon;
  final Color? iconColor;
  final TextInputType? keyboardType;
  final bool enabled;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.borderColor,
    required this.fillColor,
    this.prefixIcon,
    this.iconColor,
    this.keyboardType,
    this.enabled = true,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: screenWidth * 0.005,
            blurRadius: screenWidth * 0.01,
            offset: Offset(screenWidth * 0.005, screenHeight * 0.0025),
          ),
        ],
        borderRadius: BorderRadius.circular(screenWidth * 0.075),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        style: TextStyle(
          fontFamily: 'Anton',
          color: ColorHelpers.secondaryColor,
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          hintStyle: TextStyle(
            fontFamily: 'Anton',
            color: ColorHelpers.secondaryColor.withOpacity(0.6),
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: FaIcon(
                    prefixIcon!,
                    color:
                        iconColor ??
                        ColorHelpers.secondaryColor.withOpacity(0.7),
                    size: screenWidth * 0.05,
                  ),
                )
              : null,
          fillColor: fillColor,
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.075),
            borderSide: BorderSide(
              color: borderColor,
              width: screenWidth * 0.0075,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.075),
            borderSide: BorderSide(
              color: borderColor,
              width: screenWidth * 0.005,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.075),
            borderSide: BorderSide(
              color: borderColor.withOpacity(0.5),
              width: screenWidth * 0.005,
            ),
          ),
        ),
      ),
    );
  }
}
