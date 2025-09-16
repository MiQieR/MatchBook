import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import '../database/client.dart';

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
  
  Gender? _selectedGender;
  Education? _selectedEducation;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final fields = [
      'recommender', 'clientId', 'birthYear',
      'birthPlace', 'residence', 'height', 'weight', 'occupation',
      'familyInfo', 'annualIncome', 'selfEvaluation', 'partnerRequirements'
    ];
    
    for (String field in fields) {
      _controllers[field] = TextEditingController();
      _hasError[field] = false;
    }
    _hasError['gender'] = false;
    _hasError['education'] = false;
  }

  @override
  void dispose() {
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

    // 验证必填字段
    if (_controllers['clientId']!.text.trim().isEmpty) {
      _hasError['clientId'] = true;
      hasValidationErrors = true;
    }

    if (_selectedGender == null) {
      _hasError['gender'] = true;
      hasValidationErrors = true;
    }

    if (_selectedEducation == null) {
      _hasError['education'] = true;
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
      if (weight != null && (weight < 60 || weight > 500)) {
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
        education: drift.Value(_selectedEducation!),
        occupation: drift.Value(_controllers['occupation']!.text.trim()),
        familyInfo: drift.Value(_controllers['familyInfo']!.text.trim()),
        annualIncome: drift.Value(_controllers['annualIncome']!.text.trim()),
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
    for (var controller in _controllers.values) {
      controller.clear();
    }
    setState(() {
      _selectedGender = null;
      _selectedEducation = null;
      _hasError.updateAll((key, value) => false);
    });
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField('推荐人', 'recommender'),
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
              _buildTextField('自我评价', 'selfEvaluation', maxLines: 3),
              _buildTextField('择偶要求', 'partnerRequirements', maxLines: 3),
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
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String fieldName,
      {bool isRequired = false, bool isNumber = false, int maxLines = 1, String? hint}) {
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
              color: _hasError[fieldName]! ? Colors.red : Colors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _hasError[fieldName]! ? Colors.red : Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _hasError[fieldName]! ? Colors.red : Theme.of(context).primaryColor,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          filled: _hasError[fieldName]!,
          fillColor: _hasError[fieldName]! ? Colors.red.shade50 : null,
          labelStyle: TextStyle(
            color: _hasError[fieldName]! ? Colors.red : null,
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
          labelText: '学历 *',
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
}