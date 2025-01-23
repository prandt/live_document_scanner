import 'package:live_document_scanner/src/document_scanner_type.dart';

/// The results of a document scanning process.
class DocumentScannerResults {
  /// The number of pages scanned.
  final int? pageCount;

  /// The path to the PDF file created.
  final String? pdf;

  /// The paths to the images created.
  final List<String>? images;

  /// The type of the result.
  final DocumentScannerType? type;

  DocumentScannerResults._(
      {required this.pageCount,
      required this.pdf,
      required this.type,
      required this.images});

  /// Creates a [FlutterDocScannerResults] from a map.
  factory DocumentScannerResults.fromMap(Map<dynamic, dynamic>? map) {
    return DocumentScannerResults._(
      pageCount: map?['pageCount'],
      pdf: map?['pdf'],
      images: map?['images']?.cast<String>() ?? [],
      type: DocumentScannerType.fromString(map?['type'] ?? "pdf"),
    );
  }

  @override
  String toString() {
    return 'DocumentScannerResults{pageCount: $pageCount, pdf: $pdf, type: $type, images: $images}';
  }
}
