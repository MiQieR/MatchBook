import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import '../database/client.dart';
import '../utils/text_parser.dart';
import '../utils/plain_text_formatter.dart';
import '../utils/clipboard_helper.dart';

class InputPage extends StatefulWidget {
  final AppDatabase database;

  const InputPage({super.key, required this.database});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _hasError = {};
  final Map<String, bool> _hasWarning = {}; // 新增：警告状态
  final TextEditingController _rawTextController = TextEditingController();

  Gender? _selectedGender;
  Education? _selectedEducation;
  MaritalStatus? _selectedMaritalStatus;
  bool _isSaving = false;
  String? _parseSuccessMessage;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final fields = [
      'recommender', 'clientId', 'birthYear',
      'birthPlace', 'residence', 'height', 'weight', 'occupation',
      'familyInfo', 'annualIncome', 'car', 'house', 'children',
      'selfEvaluation', 'partnerRequirements'
    ];

    for (String field in fields) {
      _controllers[field] = TextEditingController();
      _hasError[field] = false;
      _hasWarning[field] = false; // 初始化警告状态
    }
    _hasError['gender'] = false;
    _hasError['education'] = false;
    _hasError['maritalStatus'] = false;
    _hasWarning['gender'] = false;
    _hasWarning['education'] = false;
    _hasWarning['maritalStatus'] = false;
  }

  @override
  void dispose() {
    _rawTextController.dispose();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveClient() async {
    setState(() {
      _isSaving = true;
      _hasError.updateAll((key, value) => false);
    });

    bool hasValidationErrors = false;

    // 验证必填字段：推荐人、客户编号、性别
    if (_controllers['recommender']!.text.trim().isEmpty) {
      _hasError['recommender'] = true;
      hasValidationErrors = true;
    }

    if (_controllers['clientId']!.text.trim().isEmpty) {
      _hasError['clientId'] = true;
      hasValidationErrors = true;
    }

    if (_selectedGender == null) {
      _hasError['gender'] = true;
      hasValidationErrors = true;
    }

    // 验证数字字段
    final numberFields = ['birthYear', 'height', 'weight'];
    for (String field in numberFields) {
      final text = _controllers[field]!.text.trim();
      if (text.isNotEmpty && int.tryParse(text) == null) {
        _hasError[field] = true;
        hasValidationErrors = true;
      }
    }

    // 验证出生年份范围
    final birthYearText = _controllers['birthYear']!.text.trim();
    if (birthYearText.isNotEmpty) {
      final birthYear = int.tryParse(birthYearText);
      if (birthYear != null && (birthYear < 1900 || birthYear > DateTime.now().year)) {
        _hasError['birthYear'] = true;
        hasValidationErrors = true;
      }
    }

    // 验证身高范围
    final heightText = _controllers['height']!.text.trim();
    if (heightText.isNotEmpty) {
      final height = int.tryParse(heightText);
      if (height != null && (height < 100 || height > 250)) {
        _hasError['height'] = true;
        hasValidationErrors = true;
      }
    }

    // 验证体重范围
    final weightText = _controllers['weight']!.text.trim();
    if (weightText.isNotEmpty) {
      final weight = int.tryParse(weightText);
      if (weight != null && (weight < 40 || weight > 500)) {
        _hasError['weight'] = true;
        hasValidationErrors = true;
      }
    }

    setState(() {
      _isSaving = false;
    });

    if (hasValidationErrors) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请检查高亮显示的字段并修正错误'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 保存数据
    try {
      setState(() {
        _isSaving = true;
      });

      final client = ClientsCompanion(
        clientId: drift.Value(_controllers['clientId']!.text.trim()),
        recommender: drift.Value(_controllers['recommender']!.text.trim()),
        gender: drift.Value(_selectedGender!),
        birthYear: drift.Value(_controllers['birthYear']!.text.trim().isNotEmpty
            ? int.parse(_controllers['birthYear']!.text.trim()) : 0),
        birthPlace: drift.Value(_controllers['birthPlace']!.text.trim()),
        residence: drift.Value(_controllers['residence']!.text.trim()),
        height: drift.Value(_controllers['height']!.text.trim().isNotEmpty
            ? int.parse(_controllers['height']!.text.trim()) : 0),
        weight: drift.Value(_controllers['weight']!.text.trim().isNotEmpty
            ? int.parse(_controllers['weight']!.text.trim()) : 0),
        education: drift.Value(_selectedEducation ?? Education.bachelor),
        occupation: drift.Value(_controllers['occupation']!.text.trim()),
        familyInfo: drift.Value(_controllers['familyInfo']!.text.trim()),
        annualIncome: drift.Value(_controllers['annualIncome']!.text.trim()),
        car: drift.Value(_controllers['car']!.text.trim()),
        house: drift.Value(_controllers['house']!.text.trim()),
        maritalStatus: drift.Value(_selectedMaritalStatus ?? MaritalStatus.single),
        children: drift.Value(_controllers['children']!.text.trim()),
        selfEvaluation: drift.Value(_controllers['selfEvaluation']!.text.trim()),
        partnerRequirements: drift.Value(_controllers['partnerRequirements']!.text.trim()),
      );

      await widget.database.insertClient(client);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('客户信息已成功保存'),
            backgroundColor: Colors.green,
          ),
        );
        _clearForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _clearForm() {
    _rawTextController.clear();
    for (var controller in _controllers.values) {
      controller.clear();
    }
    setState(() {
      _selectedGender = null;
      _selectedEducation = null;
      _selectedMaritalStatus = null;
      _parseSuccessMessage = null;
      _hasError.updateAll((key, value) => false);
      _hasWarning.updateAll((key, value) => false); // 清除警告状态
    });
  }

  /// 一键识别文本
  void _parseText() {
    final text = _rawTextController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入要识别的文本'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // 解析文本
      final result = ClientTextParser.parse(text);

      // 填充表单
      _fillFormFromParseResult(result);

      // 使用 WidgetsBinding 确保在下一帧更新状态
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        setState(() {
          if (result.errors.isEmpty && result.warnings.isEmpty) {
            _parseSuccessMessage = '识别成功✅，请核对信息';
          } else if (result.errors.isNotEmpty) {
            _parseSuccessMessage = '部分字段识别失败，请手动填写';
          } else {
            _parseSuccessMessage = '识别成功，请注意黄色高亮字段';
          }
        });

        // 构建消息列表
        final List<String> messages = [];

        if (result.errors.isNotEmpty) {
          messages.add('识别失败字段:');
          messages.addAll(result.errors.values);
        }

        if (result.warnings.isNotEmpty) {
          if (messages.isNotEmpty) messages.add(''); // 空行分隔
          messages.add('需要注意字段:');
          messages.addAll(result.warnings.values);
        }

        // 显示提示
        if (messages.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(messages.join('\n')),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 6),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('识别成功✅,请核对信息'),
              backgroundColor: Colors.green,
            ),
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('解析失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 从剪贴板安全粘贴（处理微信富文本崩溃问题）
  Future<void> _pasteFromClipboard() async {
    try {
      final clipboardText = await ClipboardHelper.getSanitizedClipboardText();

      if (clipboardText == null || clipboardText.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('剪贴板为空'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // 将清理后的文本设置到输入框
      setState(() {
        _rawTextController.text = clipboardText;
        _rawTextController.selection = TextSelection.collapsed(
          offset: clipboardText.length,
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('已粘贴文本'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('粘贴失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 从解析结果填充表单
  void _fillFormFromParseResult(ParseResult result) {
    if (!mounted) return;

    // 先清除所有错误和警告状态
    _hasError.updateAll((key, value) => false);
    _hasWarning.updateAll((key, value) => false);

    // 设置错误状态（识别失败的字段）
    for (var errorKey in result.errors.keys) {
      if (_hasError.containsKey(errorKey)) {
        _hasError[errorKey] = true;
      }
    }

    // 设置警告状态（需要注意的字段）
    for (var warningKey in result.warnings.keys) {
      if (_hasWarning.containsKey(warningKey)) {
        _hasWarning[warningKey] = true;
      }
    }

    // 填充文本字段
    for (var entry in result.fields.entries) {
      final fieldName = entry.key;
      final value = entry.value;

      if (value == null || value.isEmpty) continue;

      // 处理枚举类型字段
      if (fieldName == 'gender') {
        _selectedGender = Gender.values.firstWhere(
          (g) => g.label == value,
          orElse: () => Gender.male,
        );
        _hasError['gender'] = false;
      } else if (fieldName == 'education') {
        _selectedEducation = Education.values.firstWhere(
          (e) => e.label == value,
          orElse: () => Education.bachelor,
        );
        _hasError['education'] = false;
      } else if (fieldName == 'maritalStatus') {
        _selectedMaritalStatus = MaritalStatus.values.firstWhere(
          (m) => m.label == value,
          orElse: () => MaritalStatus.single,
        );
        _hasError['maritalStatus'] = false;
      } else if (_controllers.containsKey(fieldName)) {
        // 填充文本字段
        _controllers[fieldName]!.text = value;
        _hasError[fieldName] = false;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加客户'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // 判断是否为横屏模式
              final isLandscape = constraints.maxWidth >= 600;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 一键识别区域 - 始终独占
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_awesome, color: Colors.blue.shade700, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              '一键识别',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _rawTextController,
                          maxLines: 8,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          enableInteractiveSelection: true,
                          contextMenuBuilder: (context, editableTextState) {
                            // 禁用系统粘贴菜单，改用我们的安全粘贴方法
                            return const SizedBox.shrink();
                          },
                          inputFormatters: [
                            PlainTextFormatter(), // 额外防护层
                          ],
                          decoration: InputDecoration(
                            hintText: '使用下方「粘贴」按钮粘贴客户信息...\n\n例如：\n推荐：张三\n编号：12345\n性别：女\n...',
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 安全粘贴按钮
                            ElevatedButton.icon(
                              onPressed: _pasteFromClipboard,
                              icon: const Icon(Icons.content_paste),
                              label: const Text('粘贴'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (_parseSuccessMessage != null)
                              Expanded(
                                child: Text(
                                  _parseSuccessMessage!,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: _parseText,
                              icon: const Icon(Icons.smart_button),
                              label: const Text('一键识别'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  // 表单字段 - 根据横竖屏调整
                  if (isLandscape) ...[
                    // 横屏布局：多个输入框在同一行
                    Row(
                      children: [
                        Expanded(child: _buildTextField('推荐人', 'recommender', isRequired: true)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTextField('客户编号', 'clientId', isRequired: true)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _buildGenderDropdown()),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTextField('出生年份', 'birthYear', isNumber: true, hint: '如: 1990')),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('出生地', 'birthPlace')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTextField('现居地', 'residence')),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('身高', 'height', isNumber: true, hint: '单位: cm')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTextField('体重', 'weight', isNumber: true, hint: '单位: 斤')),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _buildEducationDropdown()),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTextField('职业', 'occupation')),
                      ],
                    ),
                    _buildTextField('父母职业及家人几口', 'familyInfo'),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('年收入', 'annualIncome')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildMaritalStatusDropdown()),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('车', 'car')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTextField('房', 'house')),
                      ],
                    ),
                    _buildTextField('有无小孩', 'children', hint: '男女，几个，跟谁'),
                    _buildTextField('自我评价', 'selfEvaluation', maxLines: 3),
                    _buildTextField('择偶要求', 'partnerRequirements', maxLines: 3),
                  ] else ...[
                    // 竖屏布局：保持原有的垂直布局
                    _buildTextField('推荐人', 'recommender', isRequired: true),
                    _buildTextField('客户编号', 'clientId', isRequired: true),
                    _buildGenderDropdown(),
                    _buildTextField('出生年份', 'birthYear', isNumber: true, hint: '如: 1990'),
                    _buildTextField('出生地', 'birthPlace'),
                    _buildTextField('现居地', 'residence'),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('身高', 'height', isNumber: true, hint: '单位: cm')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTextField('体重', 'weight', isNumber: true, hint: '单位: 斤')),
                      ],
                    ),
                    _buildEducationDropdown(),
                    _buildTextField('职业', 'occupation'),
                    _buildTextField('父母职业及家人几口', 'familyInfo'),
                    _buildTextField('年收入', 'annualIncome'),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('车', 'car')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTextField('房', 'house')),
                      ],
                    ),
                    _buildMaritalStatusDropdown(),
                    _buildTextField('有无小孩', 'children', hint: '男女，几个，跟谁'),
                    _buildTextField('自我评价', 'selfEvaluation', maxLines: 3),
                    _buildTextField('择偶要求', 'partnerRequirements', maxLines: 3),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveClient,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: _isSaving
                              ? const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text('保存中...'),
                                  ],
                                )
                              : const Text(
                                  '确认新增',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSaving ? null : _clearForm,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            '清空表单',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String fieldName,
      {bool isRequired = false, bool isNumber = false, int maxLines = 1, String? hint}) {
    final hasError = _hasError[fieldName]!;
    final hasWarning = _hasWarning[fieldName]!;

    // 确定边框颜色和填充颜色
    Color getBorderColor(bool isFocused) {
      if (hasError) return Colors.red;
      if (hasWarning) return Colors.orange;
      if (isFocused) return Theme.of(context).primaryColor;
      return Colors.grey.shade300;
    }

    Color? getFillColor() {
      if (hasError) return Colors.red.shade50;
      if (hasWarning) return Colors.orange.shade50;
      return null;
    }

    Color? getLabelColor() {
      if (hasError) return Colors.red;
      if (hasWarning) return Colors.orange;
      return null;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: _controllers[fieldName],
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          hintText: hint,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasError ? Colors.red : (hasWarning ? Colors.orange : Colors.grey),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: getBorderColor(false),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: getBorderColor(true),
              width: 2,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          filled: hasError || hasWarning,
          fillColor: getFillColor(),
          labelStyle: TextStyle(
            color: getLabelColor(),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<Gender>(
        decoration: InputDecoration(
          labelText: '性别 *',
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: _hasError['gender']! ? Colors.red : Colors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _hasError['gender']! ? Colors.red : Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _hasError['gender']! ? Colors.red : Theme.of(context).primaryColor,
            ),
          ),
          filled: _hasError['gender']!,
          fillColor: _hasError['gender']! ? Colors.red.shade50 : null,
          labelStyle: TextStyle(
            color: _hasError['gender']! ? Colors.red : null,
          ),
        ),
        value: _selectedGender,
        items: Gender.values.map((Gender gender) {
          return DropdownMenuItem<Gender>(
            value: gender,
            child: Text(gender.label),
          );
        }).toList(),
        onChanged: (Gender? value) {
          setState(() {
            _selectedGender = value;
            _hasError['gender'] = false;
          });
        },
      ),
    );
  }

  Widget _buildEducationDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<Education>(
        decoration: InputDecoration(
          labelText: '学历',
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: _hasError['education']! ? Colors.red : Colors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _hasError['education']! ? Colors.red : Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _hasError['education']! ? Colors.red : Theme.of(context).primaryColor,
            ),
          ),
          filled: _hasError['education']!,
          fillColor: _hasError['education']! ? Colors.red.shade50 : null,
          labelStyle: TextStyle(
            color: _hasError['education']! ? Colors.red : null,
          ),
        ),
        value: _selectedEducation,
        items: Education.values.map((Education education) {
          return DropdownMenuItem<Education>(
            value: education,
            child: Text(education.label),
          );
        }).toList(),
        onChanged: (Education? value) {
          setState(() {
            _selectedEducation = value;
            _hasError['education'] = false;
          });
        },
      ),
    );
  }

  Widget _buildMaritalStatusDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<MaritalStatus>(
        decoration: InputDecoration(
          labelText: '婚姻状态',
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: _hasError['maritalStatus']! ? Colors.red : Colors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _hasError['maritalStatus']! ? Colors.red : Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _hasError['maritalStatus']! ? Colors.red : Theme.of(context).primaryColor,
            ),
          ),
          filled: _hasError['maritalStatus']!,
          fillColor: _hasError['maritalStatus']! ? Colors.red.shade50 : null,
          labelStyle: TextStyle(
            color: _hasError['maritalStatus']! ? Colors.red : null,
          ),
        ),
        value: _selectedMaritalStatus,
        items: MaritalStatus.values.map((MaritalStatus status) {
          return DropdownMenuItem<MaritalStatus>(
            value: status,
            child: Text(status.label),
          );
        }).toList(),
        onChanged: (MaritalStatus? value) {
          setState(() {
            _selectedMaritalStatus = value;
            _hasError['maritalStatus'] = false;
          });
        },
      ),
    );
  }
}