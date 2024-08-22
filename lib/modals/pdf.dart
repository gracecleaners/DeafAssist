// pdf_model.dart
class PDFModel {
  final String name;
  final String assetPath;

  PDFModel({
    required this.name,
    required this.assetPath,
  });
}

List<PDFModel> pdfList = [
  PDFModel(name: 'Chucrh Growth', assetPath: 'assets/pdfs/1.pdf'),
  PDFModel(name: 'Hacking Web Application', assetPath: 'assets/pdfs/2.pdf'),
  PDFModel(name: 'THE DESIGN FOR A SPACE WEATHER BASED EARLY WARNING TOOL', assetPath: 'assets/pdfs/3.pdf'),
  PDFModel(name: 'Hacking Exposed Web Application', assetPath: 'assets/pdfs/4.pdf'),
  PDFModel(name: ' Master of Applied Cybersecurity', assetPath: 'assets/pdfs/5.pdf'),
  PDFModel(name: 'Put your dream to the test', assetPath: 'assets/pdfs/6.pdf'),
  // Add more PDFs as needed
];