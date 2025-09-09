import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color borderColor;
  final Color fillColor;
  final bool obscureText;
  final VoidCallback? onIconPressed;
  final IconData? prefixIcon;
  final Color? iconColor;
  final bool enabled;
  final String? Function(String?)? validator;

  const CustomPasswordField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.borderColor,
    required this.fillColor,
    required this.obscureText,
    required this.onIconPressed,
    this.prefixIcon,
    this.iconColor,
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
        obscureText: obscureText,
        enabled: enabled,
        keyboardType: TextInputType.visiblePassword,
        autocorrect: false,
        enableSuggestions: false,
        style: TextStyle(
          fontFamily: 'Anton',
          color: Colors.black,
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Anton',
            color: Colors.black.withOpacity(0.6),
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: FaIcon(
                    prefixIcon!,
                    color: iconColor ?? Colors.black.withOpacity(0.7),
                    size: screenWidth * 0.05,
                  ),
                )
              : null,
          suffixIcon: IconButton(
            icon: Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: FaIcon(
                obscureText ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                color: Colors.black.withOpacity(0.7),
                size: screenWidth * 0.05,
              ),
            ),
            onPressed: onIconPressed,
          ),
          filled: true,
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
