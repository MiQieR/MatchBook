import '../database/client.dart';

/// 文本识别结果类
class ParseResult {
  final Map<String, String?> fields;
  final Map<String, String> errors;
  final Map<String, String> warnings; // 新增：警告信息（不是错误，但需要用户注意）

  ParseResult({
    required this.fields,
    required this.errors,
    this.warnings = const {},
  });
}

/// 客户信息文本解析器
class ClientTextParser {
  /// 解析客户信息文本
  static ParseResult parse(String text) {
    final fields = <String, String?>{};
    final errors = <String, String>{};
    final warnings = <String, String>{}; // 新增警告映射

    // 定义所有字段的匹配规则
    // 注意：使用负向前瞻(?!...)来避免匹配到下一个字段的标签
    // 并且要求匹配的内容不能以常见字段名开头
    final patterns = {
      'recommender': [r'推荐[人：:]\s*([^\n：:]+?)(?=\n|$)', r'推荐.*?[:：]\s*([^\n：:]+?)(?=\n|$)'],
      'clientId': [r'编号[：:]\s*([^\n：:]+?)(?=\n|$)', r'客户编号[：:]\s*([^\n：:]+?)(?=\n|$)'],
      'gender': [r'性别[：:]\s*([^\n：:]+?)(?=\n|$)'],
      'birthPlace': [r'籍贯[：:]\s*([^\n：:]+?)(?=\n|$)', r'出生地[：:]\s*([^\n：:]+?)(?=\n|$)'],
      'residence': [r'工作地址[：:]\s*([^\n：:]+?)(?=\n|$)', r'现居地[：:]\s*([^\n：:]+?)(?=\n|$)', r'居住地[：:]\s*([^\n：:]+?)(?=\n|$)'],
      'birthYear': [r'出生年月日[：:]\s*([^\n：:]+?)(?=\n|$)', r'出生年份[：:]\s*([^\n：:]+?)(?=\n|$)', r'年份[：:]\s*([^\n：:]+?)(?=\n|$)'],
      'height': [r'身高[：:]\s*([^\n：:]+?)(?=\n|$)'],
      'weight': [r'体重[：:]\s*([^\n：:]+?)(?=\n|$)'],
      'education': [r'学历[：:]\s*([^\n：:]+?)(?=\n|$)'],
      'occupation': [r'职业[：:]\s*([^\n：:]+?)(?=\n|$)'],
      'familyInfo': [r'父母职业及家人几口[：:]\s*([^\n：:]+?)(?=\n|$)', r'家人几口[：:]\s*([^\n：:]+?)(?=\n|$)', r'父母职业[：:]\s*([^\n：:]+?)(?=\n|$)'],
      'annualIncome': [r'年收入[：:]\s*([^\n：:]+?)(?=\n|$)', r'收入[：:]\s*([^\n：:]+?)(?=\n|$)'],
      'car': [r'车[：:]\s*([^\n：:]+?)(?=\n|$)'],
      'house': [r'房[：:]\s*([^\n：:]+?)(?=\n|$)'],
      'maritalStatus': [r'婚姻状态[：:]\s*([^\n：:]+?)(?=\n|$)', r'婚姻[：:]\s*([^\n：:]+?)(?=\n|$)'],
      'children': [r'有无小孩[：:（(]\s*([^）)\n：:]+?)(?=\n|$)', r'有无小孩[：:]\s*([^\n：:]+?)(?=\n|$)'],
      'selfEvaluation': [r'❤?\s*自我评价\s*❤?[：:]\s*([^\n：:]+?)(?=\n|$)', r'自我评价[：:]\s*([^\n：:]+?)(?=\n|$)'],
      'partnerRequirements': [r'❤?\s*择偶要求\s*❤?[：:]\s*([^\n：:]+?)(?=\n|$)', r'择偶要求[：:]\s*([^\n：:]+?)(?=\n|$)'],
    };

    // 尝试匹配每个字段
    for (var entry in patterns.entries) {
      final fieldName = entry.key;
      final patternList = entry.value;

      String? value;
      for (var pattern in patternList) {
        final regex = RegExp(pattern, multiLine: true);
        final match = regex.firstMatch(text);
        if (match != null && match.group(1) != null) {
          value = match.group(1)!.trim();
          if (value.isNotEmpty) {
            break;
          }
        }
      }

      if (value != null && value.isNotEmpty) {
        // 对特定字段进行数据验证和转换
        switch (fieldName) {
          case 'birthYear':
            value = _parseBirthYear(value, errors);
            break;
          case 'height':
            value = _parseHeight(value, errors);
            break;
          case 'weight':
            value = _parseWeight(value, errors, warnings); // 传入warnings
            break;
          case 'gender':
            value = _parseGender(value, errors);
            break;
          case 'education':
            value = _parseEducation(value, errors);
            break;
          case 'maritalStatus':
            value = _parseMaritalStatus(value, errors);
            break;
        }

        // 只有当值不为 null 时才放入 fields（解析失败时会返回 null）
        if (value != null) {
          fields[fieldName] = value;
        }
      }
    }

    return ParseResult(fields: fields, errors: errors, warnings: warnings);
  }

  /// 解析出生年份
  static String? _parseBirthYear(String value, Map<String, String> errors) {
    // 移除所有空格
    value = value.replaceAll(RegExp(r'\s'), '');

    // 如果包含中文数字或其他非标准格式，先记录错误
    if (RegExp(r'[一二三四五六七八九十零〇]').hasMatch(value)) {
      errors['birthYear'] = '出生年份格式错误：含有中文数字 "$value"';
      return null;
    }

    // 尝试匹配四位数年份
    final fourDigitMatch = RegExp(r'(\d{4})').firstMatch(value);
    if (fourDigitMatch != null) {
      final year = int.parse(fourDigitMatch.group(1)!);
      if (year >= 1900 && year <= DateTime.now().year) {
        return year.toString();
      }
    }

    // 尝试纯数字两位数（如：98）
    final pureDigitMatch = RegExp(r'^(\d{2})年?$').firstMatch(value);
    if (pureDigitMatch != null) {
      final yearSuffix = int.parse(pureDigitMatch.group(1)!);
      final year = yearSuffix >= 0 && yearSuffix <= 30
          ? 2000 + yearSuffix
          : 1900 + yearSuffix;
      return year.toString();
    }

    errors['birthYear'] = '出生年份格式错误："$value"';
    return null;
  }

  /// 解析身高（单位：cm）
  static String? _parseHeight(String value, Map<String, String> errors) {
    // 检查是否使用了冒号（常见错误）
    if (value.contains(':') || value.contains('：')) {
      errors['height'] = '身高格式错误：不能使用冒号 "$value"';
      return null;
    }

    // 移除所有空格和单位
    value = value.replaceAll(RegExp(r'\s|cm|CM|厘米|公分'), '');

    // 特殊处理：如果是小数格式且小于3（如1.62、1.78），可能是米的单位
    // 自动转换为厘米（去除小数点）
    final decimalMatch = RegExp(r'^([1-2])\.(\d{2})$').firstMatch(value);
    if (decimalMatch != null) {
      final wholePart = decimalMatch.group(1)!;
      final decimalPart = decimalMatch.group(2)!;
      value = wholePart + decimalPart; // 例如：1.62 -> 162
      // 不再记录为错误，静默转换
    }

    // 如果还包含其他小数点格式，判断为错误
    if (value.contains('.') || value.contains('。')) {
      errors['height'] = '身高格式错误：不能使用小数点 "$value"（单位应为cm）';
      return null;
    }

    // 尝试解析数字
    final match = RegExp(r'(\d+)').firstMatch(value);
    if (match != null) {
      final heightStr = match.group(1)!;
      final height = int.tryParse(heightStr);

      if (height == null) {
        errors['height'] = '身高格式错误："$value"';
        return null;
      }

      // 验证身高范围（100-250cm）
      if (height < 100 || height > 250) {
        errors['height'] = '身高超出合理范围："$value" cm';
        return null;
      }

      return height.toString();
    }

    errors['height'] = '身高格式错误："$value"';
    return null;
  }

  /// 解析体重（单位：斤）
  static String? _parseWeight(String value, Map<String, String> errors, Map<String, String> warnings) {
    // 如果是小数格式，判断为错误
    if (value.contains('.') || value.contains('。')) {
      errors['weight'] = '体重格式错误：不能使用小数点 "$value"';
      return null;
    }

    // 移除所有空格和单位
    value = value.replaceAll(RegExp(r'\s|斤|公斤|kg|KG'), '');

    // 尝试解析数字
    final match = RegExp(r'(\d+)').firstMatch(value);
    if (match != null) {
      final weightStr = match.group(1)!;
      final weight = int.tryParse(weightStr);

      if (weight == null) {
        errors['weight'] = '体重格式错误："$value"';
        return null;
      }

      // 验证体重范围（40-500斤）
      if (weight < 40 || weight > 500) {
        errors['weight'] = '体重超出合理范围："$value" 斤';
        return null;
      }

      // 警告：体重小于70斤时，提示用户检查单位
      if (weight < 70) {
        warnings['weight'] = '体重较轻（$weight 斤），请检查单位是否为斤';
      }

      return weight.toString();
    }

    errors['weight'] = '体重格式错误："$value"';
    return null;
  }

  /// 解析性别
  static String? _parseGender(String value, Map<String, String> errors) {
    value = value.trim();

    if (value.contains('男')) {
      return Gender.male.label;
    } else if (value.contains('女')) {
      return Gender.female.label;
    }

    errors['gender'] = '性别识别失败："$value"';
    return null;
  }

  /// 解析学历
  static String? _parseEducation(String value, Map<String, String> errors) {
    value = value.trim();

    for (var education in Education.values) {
      if (value.contains(education.label)) {
        return education.label;
      }
    }

    errors['education'] = '学历识别失败："$value"';
    return null;
  }

  /// 解析婚姻状态
  static String? _parseMaritalStatus(String value, Map<String, String> errors) {
    value = value.trim();

    for (var status in MaritalStatus.values) {
      if (value.contains(status.label)) {
        return status.label;
      }
    }

    errors['maritalStatus'] = '婚姻状态识别失败："$value"';
    return null;
  }
}
