import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  // final String imageUrl;
  final double radius;
  final VoidCallback? onTap;

  const ProfileImageWidget({
    super.key,
   
    this.radius = 80.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: const AssetImage("assets/images/okumu.png"),
        backgroundColor: Colors.grey[200],
        child: const Align(
          alignment: Alignment.bottomRight,
          child: Icon(
            Icons.camera_alt,
            color: Colors.black,
            size: 40,
          ),
        ),
      ),
    );
  }
}
