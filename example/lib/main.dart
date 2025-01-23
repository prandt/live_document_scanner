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
  final _documentScanner = LiveDocumentScanner(
      options: DocumentScannerOptions(
          pageLimit: 1,
          type: DocumentScannerType.images,
          galleryImportAllowed: true));

  @override
  void initState() {
    super.initState();
  }

  void _scanDocument() async {
    final results = await _documentScanner.scanDocument();
    debugPrint("Results: $results");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Live Document Scanner example app'),
        ),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () => _scanDocument(), child: Text("Scan Document"))
          ],
        ),
      ),
    );
  }
}
