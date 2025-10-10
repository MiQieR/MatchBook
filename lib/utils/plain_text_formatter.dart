import 'package:flutter/services.dart';

/// 纯文本输入格式化器
/// 用于解决 iOS 上粘贴富文本（如微信消息）导致崩溃的问题
class PlainTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 移除所有不可见的控制字符和特殊格式字符
    // 但保留常见的空白字符（空格、换行、制表符）
    final cleanText = newValue.text.replaceAll(
      RegExp(r'[\x00-\x08\x0B-\x0C\x0E-\x1F\x7F-\x9F\u200B-\u200D\uFEFF]'),
      '',
    );

    // 如果文本被清理过，返回清理后的值
    if (cleanText != newValue.text) {
      return TextEditingValue(
        text: cleanText,
        selection: TextSelection.collapsed(offset: cleanText.length),
      );
    }

    return newValue;
  }
}
