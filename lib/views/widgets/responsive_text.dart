import 'package:flutter/material.dart';

class ResponsiveText extends StatelessWidget {
  final String text;

  const ResponsiveText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate a font size based on screen width
    double fontSize = screenWidth * 0.05; // 5% of screen width

    return Text(
      text,
      style: TextStyle(fontSize: fontSize),
    );
  }
}
