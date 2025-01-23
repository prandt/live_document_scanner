import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live_document_scanner/src/document_scanner_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDocumentScanner platform = MethodChannelDocumentScanner();
  const MethodChannel channel = MethodChannel('live_document_scanner');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

}
