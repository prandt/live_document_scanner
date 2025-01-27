import 'package:live_document_scanner/live_document_scanner.dart';
import 'package:live_document_scanner/src/document_scanner_platform_interface.dart';

/// The main class of the plugin
class LiveDocumentScanner {
  /// The options for the document scanner
  final DocumentScannerOptions options;

  /// Constructor
  LiveDocumentScanner({DocumentScannerOptions? options})
      : options = options ?? DocumentScannerOptions();

  /// Scan a document
  Future<DocumentScannerResults> scanDocument() {
    return DocumentScannerPlatform.instance.scanDocument(options);
  }
}
