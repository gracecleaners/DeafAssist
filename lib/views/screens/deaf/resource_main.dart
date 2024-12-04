import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/views/screens/deaf/courses_main.dart';
import 'package:deafassist/views/screens/deaf/pdf_resources.dart';
import 'package:deafassist/views/screens/deaf/videos.dart';
import 'package:deafassist/views/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:deafassist/modals/resources.dart';

class Resources extends StatelessWidget {
  const Resources({super.key});

  @override
  Widget build(BuildContext context) {

  List<ResourceIndex> resourceList = [
  ResourceIndex(
    name: 'Courses',
    onTap: () {
       Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Courses(),
        ),
      );
    },
    icon: const Icon(Icons.book, color: Colors.blue, size: 80,), // Example icon
  ),
  ResourceIndex(
    name: 'PDFs',
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PDFresources(),
        ),
      );
    },
    icon: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 80,), // Another example icon
  ),
  ResourceIndex(
    name: 'Videos',
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const VideoLists(),
        ),
      );
    },
    icon: const Icon(Icons.video_library, color: Colors.yellow, size: 80,), // Example icon
  ),
  ResourceIndex(
    name: 'Signs',
    onTap: () {
      // Handle tap
    },
    icon: const Icon(Icons.handshake, color: Colors.green, size: 80,), // Another example icon
  ),
];


    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back, color: AppColors.buttonColor,),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
              width: MediaQuery.of(context).size.width * 0.95, // Specify the width of the container
              height: 350, // Specify the height of the container
              padding: const EdgeInsets.all(10), // Add padding inside the container
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the container
                borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
              child: Image.asset(
                'assets/images/new.png', // Path to the image
                fit: BoxFit.cover, // Adjust the image to cover the container
              ),),
            ),
            const SizedBox(height: 20,), 
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: MyText(text: "Resource Index", fontSize: 25,),
            ),
            const SizedBox(height: 20,), 
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: MyText(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ips um has been the industry's standard dummy", maxLines: 10,),
            ),
        
            GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // childAspectRatio: 0.8,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              return ResourceCard(
                resource: resourceList[index],
              );
            },
            itemCount: resourceList.length,
          ),
          ],
        ),
      ),
    );
  }
}

class ResourceCard extends StatelessWidget {
  final ResourceIndex resource;
  const ResourceCard({
    super.key,
    required this.resource,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => resource.onTap(), // Ensuring `onTap` executes
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 4.0,
              spreadRadius: .05,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: resource.icon
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: MyText(text: resource.name, fontSize: 22,)),
              
          ],
        ),
      ),
    );
  }
}
