import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Setup method channel for clipboard handling
    if let controller = window?.rootViewController as? FlutterViewController {
      let clipboardChannel = FlutterMethodChannel(
        name: "com.matchmaker.clipboard",
        binaryMessenger: controller.binaryMessenger
      )

      clipboardChannel.setMethodCallHandler { [weak self] (call, result) in
        if call.method == "getSanitizedClipboard" {
          result(self?.getSanitizedClipboardText())
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Get sanitized plain text from clipboard, handling problematic WeChat rich text
  private func getSanitizedClipboardText() -> String? {
    let pasteboard = UIPasteboard.general

    // WeChat may provide text in different formats. Try them in order:

    // 1. Try public.utf8-plain-text (most reliable for WeChat)
    if let data = pasteboard.data(forPasteboardType: "public.utf8-plain-text"),
       let text = String(data: data, encoding: .utf8) {
      return cleanText(text)
    }

    // 2. Try public.plain-text
    if let data = pasteboard.data(forPasteboardType: "public.plain-text"),
       let text = String(data: data, encoding: .utf8) {
      return cleanText(text)
    }

    // 3. Try standard string (may have encoding issues with WeChat)
    if let plainText = pasteboard.string {
      return cleanText(plainText)
    }

    // 4. Try to extract from RTF
    if let rtfData = pasteboard.data(forPasteboardType: "public.rtf") {
      do {
        let nsAttributedString = try NSAttributedString(
          data: rtfData,
          options: [.documentType: NSAttributedString.DocumentType.rtf],
          documentAttributes: nil
        )
        return cleanText(nsAttributedString.string)
      } catch {
        NSLog("Failed to parse RTF: \(error)")
      }
    }

    return nil
  }

  /// Clean text by removing invisible control characters that cause Flutter JSON encoding issues
  private func cleanText(_ text: String) -> String {
    // Remove control characters and zero-width characters that WeChat embeds
    let cleaned = text.unicodeScalars.filter { scalar in
      // Keep normal whitespace (space, newline, tab)
      if scalar == "\u{0020}" || scalar == "\u{000A}" || scalar == "\u{000D}" || scalar == "\u{0009}" {
        return true
      }

      // Remove control characters (0x00-0x1F, 0x7F-0x9F)
      if scalar.value < 0x0020 || (scalar.value >= 0x007F && scalar.value <= 0x009F) {
        return false
      }

      // Remove zero-width and special formatting characters that cause issues
      let problematicRanges: [ClosedRange<UInt32>] = [
        0x200B...0x200D,  // Zero-width spaces
        0xFEFF...0xFEFF,  // Zero-width no-break space
        0x2060...0x2064,  // Word joiner and invisible operators
      ]

      for range in problematicRanges {
        if range.contains(scalar.value) {
          return false
        }
      }

      return true
    }

    return String(String.UnicodeScalarView(cleaned))
  }
}
