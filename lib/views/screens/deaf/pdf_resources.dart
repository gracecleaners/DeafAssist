import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/modals/pdf.dart';
import 'package:deafassist/views/screens/deaf/pdf_view.dart';
import 'package:deafassist/views/widgets/pdf_list.dart';
import 'package:deafassist/views/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class PDFresources extends StatelessWidget {
  const PDFresources({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PDFModel> pdfs = pdfList;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: AppColors.buttonColor),
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
                padding: EdgeInsets.all(10), // Add padding inside the container
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the container
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: Image.asset(
                  'assets/images/newpdf.png', // Path to the image
                  fit: BoxFit.cover, // Adjust the image to cover the container
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MyText(
                text: "PDF Resources",
                fontSize: 25,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MyText(
                text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy",
                maxLines: 10,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: MyText(
                text: "Resources to Enrich",
                fontSize: 22,
                color: AppColors.primaryColor,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 300, // Specify a height for the ListView
                child:   ListView.builder(
        itemCount: pdfList.length,
        itemBuilder: (context, index) {
          return PDFListItem(pdf: pdfList[index]);
        },
      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
