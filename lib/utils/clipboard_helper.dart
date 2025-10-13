import 'package:flutter/services.dart';

/// Helper class to safely get clipboard text via native platform sanitization
/// This prevents crashes from WeChat's rich text format on both iOS and Android
class ClipboardHelper {
  static const MethodChannel _channel = MethodChannel('com.matchmaker.clipboard');

  /// Get sanitized clipboard text from native platform layer
  /// Returns null if clipboard is empty or an error occurs
  static Future<String?> getSanitizedClipboardText() async {
    try {
      final String? result = await _channel.invokeMethod('getSanitizedClipboard');
      return result;
    } on PlatformException catch (e) {
      print('Failed to get clipboard text: ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected error getting clipboard: $e');
      return null;
    }
  }
}
