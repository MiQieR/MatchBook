import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../database/database.dart';
import '../database/client.dart';

class ClientEditPage extends StatefulWidget {
  final AppDatabase database;
  final Client client;

  const ClientEditPage({
    super.key,
    required this.database,
    required this.client,
  });

  @override
  State<ClientEditPage> createState() => _ClientEditPageState();
}

class _ClientEditPageState extends State<ClientEditPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _hasError = {};

  Gender? _selectedGender;
  Education? _selectedEducation;
  MaritalStatus? _selectedMaritalStatus;
  bool _isSaving = false;
  String _photoPath = '';
  String? _docDirPath;
  String? _selectedPhotoPath;
  bool _photoIsTemp = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadClientData();
    _initDocDir();
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
    }
    _hasError['gender'] = false;
    _hasError['education'] = false;
    _hasError['maritalStatus'] = false;
  }

  void _loadClientData() {
    final client = widget.client;

    _controllers['recommender']!.text = client.recommender;
    _controllers['clientId']!.text = client.clientId;
    _controllers['birthYear']!.text = client.birthYear > 0 ? client.birthYear.toString() : '';
    _controllers['birthPlace']!.text = client.birthPlace;
    _controllers['residence']!.text = client.residence;
    _controllers['height']!.text = client.height > 0 ? client.height.toString() : '';
    _controllers['weight']!.text = client.weight > 0 ? client.weight.toString() : '';
    _controllers['occupation']!.text = client.occupation;
    _controllers['familyInfo']!.text = client.familyInfo;
    _controllers['annualIncome']!.text = client.annualIncome;
    _controllers['car']!.text = client.car;
    _controllers['house']!.text = client.house;
    _controllers['children']!.text = client.children;
    _controllers['selfEvaluation']!.text = client.selfEvaluation;
    _controllers['partnerRequirements']!.text = client.partnerRequirements;

    _selectedGender = client.gender;
    _selectedEducation = client.education;
    _selectedMaritalStatus = client.maritalStatus;
    _photoPath = client.photoPath;
  }

  Future<void> _initDocDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(path.join(dir.path, 'photos'));
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }
    if (mounted) {
      setState(() {
        _docDirPath = dir.path;
        if (_photoPath.isNotEmpty) {
          _selectedPhotoPath = path.join(dir.path, _photoPath);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    if (_selectedPhotoPath != null && _photoIsTemp) {
      final tempFile = File(_selectedPhotoPath!);
      if (tempFile.existsSync()) {
        tempFile.deleteSync();
      }
    }
    super.dispose();
  }

  String _defaultPhotoAsset(Gender gender) {
    return gender == Gender.male
        ? 'img/user_default_male.jpg'
        : 'img/user_default_female.jpg';
  }

  Future<String?> _prepareCropSource(XFile picked) async {
    final pickedPath = picked.path;
    if (pickedPath.isNotEmpty) {
      final file = File(pickedPath);
      if (await file.exists()) {
        return pickedPath;
      }
    }

    final bytes = await picked.readAsBytes();
    final tempDir = await getTemporaryDirectory();
    final tempPath = path.join(
      tempDir.path,
      'picked_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    final tempFile = File(tempPath);
    await tempFile.writeAsBytes(bytes, flush: true);
    return tempPath;
  }

  Future<void> _pickPhoto() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      final sourcePath = await _prepareCropSource(picked);
      if (sourcePath == null) return;

      final cropped = await ImageCropper().cropImage(
        sourcePath: sourcePath,
        aspectRatio: const CropAspectRatio(ratioX: 2, ratioY: 3),
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '裁剪照片',
            hideBottomControls: false,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: '裁剪照片',
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (cropped == null) return;

      if (_selectedPhotoPath != null && _photoIsTemp) {
        final oldTemp = File(_selectedPhotoPath!);
        if (await oldTemp.exists()) {
          await oldTemp.delete();
        }
      }

      final baseDir = _docDirPath;
      if (baseDir == null) {
        setState(() {
          _selectedPhotoPath = cropped.path;
          _photoIsTemp = true;
        });
        return;
      }

      final photosDir = path.join(baseDir, 'photos');
      final tempName = 'temp_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final targetPath = path.join(photosDir, tempName);
      await File(cropped.path).copy(targetPath);

      setState(() {
        _selectedPhotoPath = targetPath;
        _photoIsTemp = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('选择照片失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveClient() async {
    setState(() {
      _isSaving = true;
      _hasError.updateAll((key, value) => false);
    });

    bool hasValidationErrors = false;

    // 验证必填字段：姓名、客户编号、性别
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

      String updatedPhotoPath = _photoPath;
      final newClientId = _controllers['clientId']!.text.trim();
      final baseDir = _docDirPath;
      if (baseDir != null && newClientId.isNotEmpty) {
        final photosDir = path.join(baseDir, 'photos');
        final newRelative = path.join('photos', '$newClientId.jpg');
        final newAbsolute = path.join(photosDir, '$newClientId.jpg');

        if (_selectedPhotoPath != null) {
          if (_selectedPhotoPath != newAbsolute) {
            await File(_selectedPhotoPath!).copy(newAbsolute);
            await FileImage(File(newAbsolute)).evict();
          }

          if (_photoIsTemp) {
            final tempFile = File(_selectedPhotoPath!);
            if (await tempFile.exists()) {
              await tempFile.delete();
            }
          } else if (_selectedPhotoPath!.startsWith(photosDir) &&
              _selectedPhotoPath != newAbsolute) {
            final oldFile = File(_selectedPhotoPath!);
            if (await oldFile.exists()) {
              await oldFile.delete();
            }
          }

          if (_photoPath.isNotEmpty && _photoPath != newRelative) {
            final oldAbsolute = path.join(baseDir, _photoPath);
            if (await File(oldAbsolute).exists()) {
              await File(oldAbsolute).delete();
            }
          }

          updatedPhotoPath = newRelative;
          _photoIsTemp = false;
          _selectedPhotoPath = newAbsolute;
        } else if (_photoPath.isNotEmpty) {
          final oldAbsolute = path.join(baseDir, _photoPath);
          if (_photoPath != newRelative && await File(oldAbsolute).exists()) {
            await File(oldAbsolute).copy(newAbsolute);
            await File(oldAbsolute).delete();
          }
          updatedPhotoPath = newRelative;
        }
      }

      final updatedClient = Client(
        clientId: _controllers['clientId']!.text.trim(),
        recommender: _controllers['recommender']!.text.trim(),
        gender: _selectedGender!,
        birthYear: _controllers['birthYear']!.text.trim().isNotEmpty
            ? int.parse(_controllers['birthYear']!.text.trim()) : 0,
        birthPlace: _controllers['birthPlace']!.text.trim(),
        residence: _controllers['residence']!.text.trim(),
        height: _controllers['height']!.text.trim().isNotEmpty
            ? int.parse(_controllers['height']!.text.trim()) : 0,
        weight: _controllers['weight']!.text.trim().isNotEmpty
            ? int.parse(_controllers['weight']!.text.trim()) : 0,
        education: _selectedEducation ?? Education.bachelor,
        occupation: _controllers['occupation']!.text.trim(),
        familyInfo: _controllers['familyInfo']!.text.trim(),
        annualIncome: _controllers['annualIncome']!.text.trim(),
        car: _controllers['car']!.text.trim(),
        house: _controllers['house']!.text.trim(),
        maritalStatus: _selectedMaritalStatus ?? MaritalStatus.single,
        children: _controllers['children']!.text.trim(),
        photoPath: updatedPhotoPath,
        selfEvaluation: _controllers['selfEvaluation']!.text.trim(),
        partnerRequirements: _controllers['partnerRequirements']!.text.trim(),
      );

      await widget.database.updateClient(updatedClient);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('客户信息已更新'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // 返回并刷新
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

  bool get _hasUnsavedChanges {
    final c = widget.client;
    bool textChanged(String key, String original) => _controllers[key]!.text != original;
    bool intChanged(String key, int original) {
      final text = _controllers[key]!.text.trim();
      final val = text.isEmpty ? 0 : int.tryParse(text) ?? 0;
      return val != original;
    }

    if (textChanged('recommender', c.recommender)) return true;
    if (intChanged('birthYear', c.birthYear)) return true;
    if (textChanged('birthPlace', c.birthPlace)) return true;
    if (textChanged('residence', c.residence)) return true;
    if (intChanged('height', c.height)) return true;
    if (intChanged('weight', c.weight)) return true;
    if (textChanged('occupation', c.occupation)) return true;
    if (textChanged('familyInfo', c.familyInfo)) return true;
    if (textChanged('annualIncome', c.annualIncome)) return true;
    if (textChanged('car', c.car)) return true;
    if (textChanged('house', c.house)) return true;
    if (textChanged('children', c.children)) return true;
    if (textChanged('selfEvaluation', c.selfEvaluation)) return true;
    if (textChanged('partnerRequirements', c.partnerRequirements)) return true;

    if (_selectedGender != c.gender) return true;
    if (_selectedEducation != c.education) return true;
    if (_selectedMaritalStatus != c.maritalStatus) return true;

    String? originalAbsPath;
    if (_docDirPath != null && c.photoPath.isNotEmpty) {
      originalAbsPath = path.join(_docDirPath!, c.photoPath);
    }
    if (_selectedPhotoPath != originalAbsPath) return true;

    return false;
  }

  Future<void> _handlePop(bool didPop) async {
    if (didPop) return;

    if (!_hasUnsavedChanges) {
      Navigator.pop(context);
      return;
    }

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('未保存的更改'),
        content: const Text('您有未保存的更改，是否保存？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 0), // Don't Save
            child: const Text('不保存', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 1), // Cancel
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 2), // Save
            child: const Text('保存'),
          ),
        ],
      ),
    );

    if (result == null || result == 1) return; // Cancel or dismiss

    if (result == 2) {
      await _saveClient();
    } else {
      if (mounted) Navigator.pop(context); // Don't save, just leave
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: _handlePop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('编辑客户'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildTextField('姓名', 'recommender', isRequired: true),
                          _buildTextField('客户编号', 'clientId', isRequired: true, enabled: false),
                          _buildGenderDropdown(bottomPadding: 0),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: _buildPhotoBox(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveClient,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                              '保存修改',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        '取消',
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
      ),
    );
  }

  Widget _buildPhotoBox() {
    final resolved = _selectedPhotoPath ??
        (_docDirPath != null && _photoPath.isNotEmpty
            ? path.join(_docDirPath!, _photoPath)
            : null);
    final gender = _selectedGender;
    Widget content;
    if (resolved != null) {
      content = Image.file(
        File(resolved),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          if (gender == null) {
            return _buildPhotoPlaceholder();
          }
          return Image.asset(_defaultPhotoAsset(gender), fit: BoxFit.cover);
        },
      );
    } else if (gender != null) {
      content = Image.asset(
        _defaultPhotoAsset(gender),
        fit: BoxFit.cover,
      );
    } else {
      content = _buildPhotoPlaceholder();
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _pickPhoto,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: content,
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_a_photo_outlined,
          color: Colors.grey.shade500,
          size: 28,
        ),
        const SizedBox(height: 6),
        Text(
          '添加照片',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String fieldName,
      {bool isRequired = false, bool isNumber = false, int maxLines = 1, String? hint, bool enabled = true}) {
    final hasError = _hasError[fieldName]!;

    Color getBorderColor(bool isFocused) {
      if (hasError) return Colors.red;
      if (isFocused) return Theme.of(context).primaryColor;
      return Colors.grey.shade300;
    }

    Color? getFillColor() {
      if (hasError) return Colors.red.shade50;
      return null;
    }

    Color? getLabelColor() {
      if (hasError) return Colors.red;
      return null;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: _controllers[fieldName],
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          hintText: hint,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasError ? Colors.red : Colors.grey,
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
          filled: hasError,
          fillColor: getFillColor(),
          labelStyle: TextStyle(
            color: getLabelColor(),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown({double bottomPadding = 12.0}) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
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
        initialValue: _selectedGender,
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
        initialValue: _selectedEducation,
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
        initialValue: _selectedMaritalStatus,
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
