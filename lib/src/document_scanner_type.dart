/// Enum for the type of the document scanner
enum DocumentScannerType {
  /// PDF document scanner
  pdf._('pdf'),

  /// Images document scanner
  images._('images');

  /// The name of the type
  final String name;

  const DocumentScannerType._(this.name);

  @override
  toString() => name;

  factory DocumentScannerType.fromString(type) => DocumentScannerType.values
      .firstWhere((e) => e.name == type, orElse: () => DocumentScannerType.pdf);
}
