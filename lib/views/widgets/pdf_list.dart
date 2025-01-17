// pdf_list_item.dart
import 'package:deafassist/modals/pdf.dart';
import 'package:deafassist/views/screens/deaf/pdf_view.dart';
import 'package:deafassist/views/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class PDFListItem extends StatelessWidget {
  final PDFModel pdf;

  const PDFListItem({super.key, required this.pdf});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
        title: MyText(text: pdf.name),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFViewPage(pdf: pdf),
              ),
            );
          },
          child: const Text('Read More'),
        ),
      ),
    );
  }
}
