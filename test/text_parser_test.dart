import 'package:flutter_test/flutter_test.dart';
import 'package:matchmaker_db/utils/text_parser.dart';

void main() {
  group('ClientTextParser Tests', () {
    test('应该正确解析完整的客户信息', () {
      const testText = '''
推荐：李桂英
编号：29991
性别：女
籍贯：徐水
工作地址：保定儿童医院
出生年月日：九八年
身高：1.58
体重：45
学历：本科
职业：在编护士
父母职业及家人几口：爸妈妹妹
年收入：正常
车：
房：
婚姻状态：未婚
有无小孩（男女，几个，跟谁）：
❤自我评价：温柔善良，知书达理，
❤择偶要求❤：人品好三关正有责任和担当，本科学历，保定有房的有缘人。
''';

      final result = ClientTextParser.parse(testText);

      // 验证成功解析的字段
      expect(result.fields['recommender'], '李桂英');
      expect(result.fields['clientId'], '29991');
      expect(result.fields['gender'], '女');
      expect(result.fields['birthPlace'], '徐水');
      expect(result.fields['residence'], '保定儿童医院');
      expect(result.fields['education'], '本科');
      expect(result.fields['occupation'], '在编护士');
      expect(result.fields['maritalStatus'], '未婚');

      // 验证错误识别的字段
      expect(result.errors.containsKey('birthYear'), true,
          reason: '出生年份应该被标记为错误（含中文）');
      expect(result.fields['height'], '158',
          reason: '身高应该自动从米转换为cm');
      expect(result.warnings['weight'], '体重较轻（45 斤），请检查单位是否为斤',
          reason: '体重45斤应该有警告');
    });

    test('应该正确解析出生年份 - 四位数', () {
      const testText = '出生年月日：1998';
      final result = ClientTextParser.parse(testText);
      expect(result.fields['birthYear'], '1998');
      expect(result.errors.containsKey('birthYear'), false);
    });

    test('应该正确解析出生年份 - 两位数（98年）', () {
      const testText = '出生年月日：98年';
      final result = ClientTextParser.parse(testText);
      expect(result.fields['birthYear'], '1998');
      expect(result.errors.containsKey('birthYear'), false);
    });

    test('应该拒绝中文数字的出生年份', () {
      const testText = '出生年月日：九八年';
      final result = ClientTextParser.parse(testText);
      expect(result.fields.containsKey('birthYear'), false);
      expect(result.errors.containsKey('birthYear'), true);
    });

    test('应该正确解析身高 - 整数cm', () {
      const testText = '身高：158';
      final result = ClientTextParser.parse(testText);
      expect(result.fields['height'], '158');
      expect(result.errors.containsKey('height'), false);
    });

    test('应该拒绝身高带冒号（不匹配）', () {
      const testText = '身高：1:58';
      final result = ClientTextParser.parse(testText);
      // 带冒号的值会被正则阻止匹配，因此字段不会被填充
      expect(result.fields.containsKey('height'), false);
    });

    test('应该正确解析身高 - 米单位自动转换', () {
      const testText = '身高：1.62';
      final result = ClientTextParser.parse(testText);
      expect(result.fields['height'], '162');
      expect(result.errors.containsKey('height'), false);
    });

    test('应该正确处理空字段不会错位 - 例1', () {
      const testText = '''
年收入：正常
车：
房：17年盖的房
婚姻状态：未婚
''';
      final result = ClientTextParser.parse(testText);

      // 验证车字段为空（不应该匹配到"房：17年盖的房"）
      expect(result.fields.containsKey('car'), false);

      // 验证房字段正确识别
      expect(result.fields['house'], '17年盖的房');

      // 验证婚姻状态正确识别
      expect(result.fields['maritalStatus'], '未婚');
    });

    test('应该正确处理空字段不会错位 - 例2', () {
      const testText = '''
年收入：正常
车：
房：
婚姻状态：未婚
有无小孩：无
''';
      final result = ClientTextParser.parse(testText);

      // 验证车和房字段为空（不应该错位）
      expect(result.fields.containsKey('car'), false);
      expect(result.fields.containsKey('house'), false);

      // 验证婚姻状态正确识别（不应该被放到house字段）
      expect(result.fields['maritalStatus'], '未婚');

      // 验证有无小孩正确识别
      expect(result.fields['children'], '无');
    });

    test('应该正确解析体重', () {
      const testText = '体重：45';
      final result = ClientTextParser.parse(testText);
      expect(result.fields['weight'], '45');
      expect(result.errors.containsKey('weight'), false);
    });

    test('应该正确解析性别', () {
      const testText1 = '性别：男';
      final result1 = ClientTextParser.parse(testText1);
      expect(result1.fields['gender'], '男');

      const testText2 = '性别：女';
      final result2 = ClientTextParser.parse(testText2);
      expect(result2.fields['gender'], '女');
    });

    test('应该正确解析学历', () {
      const testText = '学历：本科';
      final result = ClientTextParser.parse(testText);
      expect(result.fields['education'], '本科');
      expect(result.errors.containsKey('education'), false);
    });

    test('应该正确解析婚姻状态', () {
      const testText = '婚姻状态：未婚';
      final result = ClientTextParser.parse(testText);
      expect(result.fields['maritalStatus'], '未婚');
      expect(result.errors.containsKey('maritalStatus'), false);
    });
  });
}
