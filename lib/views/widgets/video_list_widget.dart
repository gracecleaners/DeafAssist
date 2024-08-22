import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/views/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class VideoListWidget extends StatelessWidget {
  final String myText;
  const VideoListWidget({super.key, required this.myText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: 50,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.primaryColor
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.video_chat_rounded, color: AppColors.backgroundColor,),
              MyText(text: myText, color: AppColors.backgroundColor,)
            ],
          ),
        ),
      ),
    );
  }
}