import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final String searchQuery;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? fillColor;
  final Color? borderColor;
  final Color? iconColor;
  final Color? hintColor;
  final double? borderRadius;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  const CustomSearchBar({
    Key? key,
    required this.hintText,
    required this.onChanged,
    required this.searchQuery,
    this.margin,
    this.padding,
    this.fillColor,
    this.borderColor,
    this.iconColor,
    this.hintColor,
    this.borderRadius,
    this.textStyle,
    this.hintStyle,
  }) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(CustomSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _controller.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin:
          widget.margin ??
          EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style:
            widget.textStyle ??
            TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w500,
            ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle:
              widget.hintStyle ??
              TextStyle(
                color: widget.hintColor ?? Colors.grey.shade400,
                fontSize: screenWidth * 0.04,
              ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: widget.iconColor ?? Colors.grey.shade600,
              size: screenWidth * 0.045,
            ),
          ),
          suffixIcon: widget.searchQuery.isNotEmpty
              ? IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.xmark,
                    color: widget.iconColor ?? Colors.grey.shade600,
                    size: screenWidth * 0.04,
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: widget.fillColor ?? Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? screenWidth * 0.06,
            ),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? screenWidth * 0.06,
            ),
            borderSide: BorderSide(
              color: widget.borderColor ?? Colors.transparent,
              width: screenWidth * 0.002,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? screenWidth * 0.06,
            ),
            borderSide: BorderSide(
              color: widget.borderColor ?? Colors.blue.shade300,
              width: screenWidth * 0.005,
            ),
          ),
          contentPadding:
              widget.padding ??
              EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.015,
              ),
        ),
      ),
    );
  }
}
