# Live Document Scanner
<p>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

|                | Android | iOS       |
|----------------|---------|-----------|
| **Support**    | SDK 21+ | iOS 13.0+ |


## Installation

Add the following dependency to your pubspec.yaml file:

```yaml
dependencies:
  live_document_scanner: ^0.0.1
```

or install it directly from the command line:

```bash
flutter pub add live_document_scanner
```


## Setup

### Android
Change the minimum Android sdk version to 21 (or higher) in your android/app/build.gradle file.

```groovy
minSdkVersion 21
```

### iOS

Add the following keys to your Info.plist file, located in `<project root>/ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera permission is required for document scanning.</string>
```

## Usage

Import the package
```dart
import 'package:live_document_scanner/live_document_scanner.dart';
```

Create a new instance of the LiveDocumentScanner
```dart
LiveDocumentScanner scanner = LiveDocumentScanner(
    options: DocumentScannerOptions(
        pageLimit: 1,
        type: DocumentScannerType.images,
        galleryImportAllowed: true));
```

Start the document scanning process
```dart
DocumentScannerResults results = await scanner.scanDocument();
```

## Plugin History

This plugin was originally a **fork** of [flutter_doc_scanner](https://pub.dev/packages/flutter_doc_scanner), with the goal of extending its functionality and simplifying its usage. The main improvements include:

- **Added Typing**:
    - Introduced options with clear typing, enhancing the development experience.
    - Added typed return values, ensuring more safety and predictability when handling results.

- **Code Simplification**:
    - The codebase was optimized and reorganized, making it cleaner, easier to maintain, and more efficient.

These enhancements allow developers to integrate document scanning into their applications more seamlessly and effectively.


## License 

This project is licensed under the [MIT License](LICENSE).