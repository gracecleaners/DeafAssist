import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final String labelText;
  final TextStyle? labelStyle;
  final Widget? suffixIcon;
  final Color fillColor;
  final Color iconColor;

  const SearchTextField({
    Key? key,
    this.labelText = "Search your topic",
    this.labelStyle,
    this.suffixIcon,
    this.fillColor = Colors.white,
    this.iconColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: iconColor,
          size: 26,
        ),
        suffixIcon: suffixIcon ?? Icon(
          Icons.mic,
          color: const Color(0xFFF8B11B),
          size: 26,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: labelText,
        labelStyle: labelStyle ?? const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none,
        ),
        isDense: true,
      ),
    );
  }
}
