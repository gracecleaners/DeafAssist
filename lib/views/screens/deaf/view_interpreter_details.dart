import 'package:deafassist/modals/interpreter_info.dart';
import 'package:deafassist/views/widgets/detail_image.dart';
import 'package:deafassist/views/widgets/profile_detail.dart';
import 'package:flutter/material.dart';

import '../../../const/app_colors.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.interpreter});
  final Interpreter interpreter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Pass the interpreter to ProductDetailImages
            ProductDetailImages(interpreter: interpreter),
            // Pass the interpreter to ProductItemsDetail
            ProductItemsDetail(interpreter: interpreter),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
