import 'package:deafassist/modals/interpreter_info.dart';
import 'package:deafassist/views/widgets/curve_mage_side.dart';
import 'package:flutter/material.dart';

class ProductDetailImages extends StatelessWidget {
  final Interpreter interpreter;

  const ProductDetailImages({super.key, required this.interpreter});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ClipPath(
      clipper: CurveImageSide(),
      child: Align(
        alignment: Alignment.topCenter,
        child: Center(
          child: Hero(
            tag: interpreter.profileImageUrl,
            child: Image(
              fit: BoxFit.cover,
              height: size.height * 0.5,
              width: size.width,
              image: interpreter.profileImageUrl.isNotEmpty
                  ? NetworkImage(interpreter.profileImageUrl) // Use NetworkImage for remote URLs
                  : const AssetImage('assets/default_profile.png'), // Default image if URL is empty
            ),
          ),
        ),
      ),
    );
  }
}
