import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/views/widgets/search.dart';
import 'package:deafassist/views/widgets/text_widget.dart';
import 'package:deafassist/views/widgets/video_list_widget.dart';
import 'package:flutter/material.dart';

class VideoLists extends StatelessWidget {
  const VideoLists({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: MyText(text: "Video Resources", fontSize: 22),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SearchTextField(
              suffixIcon: Icon(Icons.send),
              fillColor: const Color.fromARGB(255, 196, 195, 195).withOpacity(0.9),
              labelText: "Search for video by name",
              labelStyle: TextStyle(color: AppColors.buttonColor),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(16, (index) => VideoListWidget(myText: "Video ${index + 1}")),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
