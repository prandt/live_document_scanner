import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'document_scanner_method_channel.dart';
import 'document_scanner_options.dart';
import 'document_scanner_results.dart';

/// The interface that implementations of document_scanner must implement.
abstract class DocumentScannerPlatform extends PlatformInterface {
  /// Constructs a LiveDocumentScannerPlatform.
  DocumentScannerPlatform() : super(token: _token);

  static final Object _token = Object();

  static DocumentScannerPlatform _instance = MethodChannelDocumentScanner();

  /// The default instance of [DocumentScannerPlatform] to use.
  ///
  /// Defaults to [MethodChannelDocumentScanner].
  static DocumentScannerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DocumentScannerPlatform] when
  /// they register themselves.
  static set instance(DocumentScannerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Starts the document scanning process.
  Future<DocumentScannerResults> scanDocument(DocumentScannerOptions options) {
    throw UnimplementedError('scanDocument() has not been implemented.');
  }
}
