import 'package:flutter/material.dart';
import 'package:live_document_scanner/live_document_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String>? imagesPath;
  String? pdfPath;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Live Document Scanner example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () => _scanDocumentImages(),
                    child: Text("Scan Document - Images")),
                const SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () => _scanDocumentPdf(),
                    child: Text("Scan Document - PDF")),
                const SizedBox(height: 16),
                if (imagesPath != null) Text("Images: ${imagesPath!.join(", ")}"),
                if (pdfPath != null) Text("PDF: $pdfPath"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _scanDocumentImages() async {
    final scanner = LiveDocumentScanner(
        options: DocumentScannerOptions(
            pageLimit: 1,
            type: DocumentScannerType.images,
            galleryImportAllowed: true));
    final results = await scanner.scanDocument();
    setState(() {
      imagesPath = results.images;
    });
  }

  void _scanDocumentPdf() async {
    final scanner = LiveDocumentScanner(
        options: DocumentScannerOptions(
            pageLimit: 10,
            type: DocumentScannerType.pdf,
            galleryImportAllowed: false));
    final results = await scanner.scanDocument();
    setState(() {
      imagesPath = results.images;
    });
  }
}
