# Live Document Scanner
<p>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>
A Flutter plugin for Android and iOS.

|                | Android | iOS       |
|----------------|---------|-----------|
| **Support**    | SDK 21+ | iOS 13.0+ |

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

## License 

This project is licensed under the [MIT License](LICENSE).