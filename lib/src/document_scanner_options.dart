import 'package:live_document_scanner/src/document_scanner_type.dart';

/// The options for the document scanner.
class DocumentScannerOptions {
  /// The maximum number of pages that can be scanned.
  /// This is only supported on Android.
  final int pageLimit;
  /// Whether the user is allowed to import images from the gallery.
  /// This is only supported on Android.
  final bool galleryImportAllowed;
  /// The type of document scanner to use.
  final DocumentScannerType type;

  /// Creates a new instance of [DocumentScannerOptions].
  DocumentScannerOptions({
    this.pageLimit = 5,
    this.galleryImportAllowed = true,
    this.type = DocumentScannerType.pdf
  });

  /// Converts the options to a map.
  Map<String, dynamic> toMap() {
    return {
      'pageLimit': pageLimit,
      'galleryImportAllowed': galleryImportAllowed,
      'type': type.toString()
    };
  }
}