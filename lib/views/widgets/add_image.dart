import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  // final String imageUrl;
  final double radius;
  final VoidCallback? onTap;

  const ProfileImageWidget({
    Key? key,
   
    this.radius = 80.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage("assets/images/okumu.png"),
        backgroundColor: Colors.grey[200],
        child: Align(
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
