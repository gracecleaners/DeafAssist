// pdf_view_page.dart
import 'package:deafassist/modals/pdf.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewPage extends StatelessWidget {
  final PDFModel pdf;

  const PDFViewPage({super.key, required this.pdf});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(pdf.name),
      ),
      body: SfPdfViewer.asset(
        pdf.assetPath,
      ),
    );
  }
}
