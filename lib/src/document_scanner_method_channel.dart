import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:live_document_scanner/src/document_scanner_results.dart';
import 'document_scanner_options.dart';
import 'document_scanner_platform_interface.dart';

/// An implementation of [DocumentScannerPlatform] that uses method channels.
class MethodChannelDocumentScanner extends DocumentScannerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('live_document_scanner');

  @override
  Future<DocumentScannerResults> scanDocument(DocumentScannerOptions options) async {
    final data = await methodChannel.invokeMethod<dynamic>(
      'scanDocument',
      options.toMap(),
    );

    return DocumentScannerResults.fromMap(data);
  }
}
