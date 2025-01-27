import 'package:flutter_test/flutter_test.dart';
import 'package:live_document_scanner/src/document_scanner_options.dart';
import 'package:live_document_scanner/src/document_scanner_platform_interface.dart';
import 'package:live_document_scanner/src/document_scanner_results.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLiveDocumentScannerPlatform
    with MockPlatformInterfaceMixin
    implements DocumentScannerPlatform {
  @override
  Future<DocumentScannerResults> scanDocument(DocumentScannerOptions options) {
    throw UnimplementedError();
  }
}

void main() {
  final DocumentScannerPlatform initialPlatform =
      DocumentScannerPlatform.instance;
}
