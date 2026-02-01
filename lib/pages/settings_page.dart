import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme_provider.dart' as theme_utils;
import '../database/database.dart';
import '../database/client.dart';
import '../widgets/modern_card.dart';
import '../widgets/gradient_button.dart';
import 'about_page.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'dart:io';

class SettingsPage extends StatefulWidget {
  final AppDatabase database;

  const SettingsPage({super.key, required this.database});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _showThemeDialog() async {
    final themeProvider = Provider.of<theme_utils.ThemeProvider>(context, listen: false);
    final currentMode = themeProvider.themeMode;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('选择主题模式'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<theme_utils.ThemeMode>(
                title: const Text('亮色模式'),
                value: theme_utils.ThemeMode.light,
                groupValue: currentMode,
                onChanged: (value) {
                  if (value != null) {
                    themeProvider.setThemeMode(value);
                    Navigator.pop(context);
                  }
                },
              ),
              RadioListTile<theme_utils.ThemeMode>(
                title: const Text('深色模式'),
                value: theme_utils.ThemeMode.dark,
                groupValue: currentMode,
                onChanged: (value) {
                  if (value != null) {
                    themeProvider.setThemeMode(value);
                    Navigator.pop(context);
                  }
                },
              ),
              RadioListTile<theme_utils.ThemeMode>(
                title: const Text('跟随系统'),
                value: theme_utils.ThemeMode.system,
                groupValue: currentMode,
                onChanged: (value) {
                  if (value != null) {
                    themeProvider.setThemeMode(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _exportData() async {
    try {
      // 获取所有客户数据
      final clients = await widget.database.getAllClients();
      final documentsDir = await getApplicationDocumentsDirectory();

      if (clients.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('没有数据可导出'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // 将数据转换为JSON
      final data = {
        'version': 2,
        'exportTime': DateTime.now().toIso8601String(),
        'clients': clients.map((c) => {
          'clientId': c.clientId,
          'recommender': c.recommender,
          'gender': c.gender.index,
          'birthYear': c.birthYear,
          'birthPlace': c.birthPlace,
          'residence': c.residence,
          'height': c.height,
          'weight': c.weight,
          'education': c.education.index,
          'occupation': c.occupation,
          'familyInfo': c.familyInfo,
          'annualIncome': c.annualIncome,
          'car': c.car,
          'house': c.house,
          'maritalStatus': c.maritalStatus.index,
          'children': c.children,
          'photoPath': c.photoPath,
          'selfEvaluation': c.selfEvaluation,
          'partnerRequirements': c.partnerRequirements,
        }).toList(),
      };

      final jsonString = jsonEncode(data);
      final jsonBytes = utf8.encode(jsonString);

      final archive = Archive();
      archive.addFile(ArchiveFile('data.json', jsonBytes.length, jsonBytes));

      for (final client in clients) {
        if (client.photoPath.isEmpty) continue;
        final absolutePath = path.join(documentsDir.path, client.photoPath);
        final photoFile = File(absolutePath);
        if (!await photoFile.exists()) continue;
        final photoBytes = await photoFile.readAsBytes();
        archive.addFile(ArchiveFile(client.photoPath, photoBytes.length, photoBytes));
      }

      final zipBytes = ZipEncoder().encode(archive);

      // 选择保存位置
      final String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: '导出数据',
        fileName: 'matchmaker_data_${DateTime.now().millisecondsSinceEpoch}.zip',
        bytes: Uint8List.fromList(zipBytes),
      );

      if (outputPath != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('成功导出 ${clients.length} 条数据'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('导出失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _importData() async {
    try {
      // 选择文件
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'zip'],
      );

      if (result == null) return;

      final file = File(result.files.single.path!);
      final extension = path.extension(file.path).toLowerCase();
      Map<String, dynamic> data;

      if (extension == '.zip') {
        final bytes = await file.readAsBytes();
        final archive = ZipDecoder().decodeBytes(bytes);
        final dataFile = archive.files.firstWhere(
          (f) => f.name == 'data.json',
          orElse: () => throw Exception('压缩包中未找到 data.json'),
        );
        if (!dataFile.isFile) {
          throw Exception('压缩包中的 data.json 无效');
        }
        final jsonString = utf8.decode(dataFile.content as List<int>);
        data = jsonDecode(jsonString) as Map<String, dynamic>;

        final documentsDir = await getApplicationDocumentsDirectory();
        for (final entry in archive.files) {
          if (!entry.isFile) continue;
          if (!entry.name.startsWith('photos/')) continue;
          final targetPath = path.join(documentsDir.path, entry.name);
          final targetFile = File(targetPath);
          await targetFile.parent.create(recursive: true);
          await targetFile.writeAsBytes(entry.content as List<int>, flush: true);
        }
      } else {
        final jsonString = await file.readAsString();
        data = jsonDecode(jsonString) as Map<String, dynamic>;
      }

      // 验证数据格式
      if (!data.containsKey('clients') || data['clients'] is! List) {
        throw Exception('无效的数据格式');
      }

      final importedClients = (data['clients'] as List).map((item) {
        return Client(
          clientId: item['clientId'] as String,
          recommender: item['recommender'] as String,
          gender: Gender.values[item['gender'] as int],
          birthYear: item['birthYear'] as int,
          birthPlace: item['birthPlace'] as String,
          residence: item['residence'] as String,
          height: item['height'] as int,
          weight: item['weight'] as int,
          education: Education.values[item['education'] as int],
          occupation: item['occupation'] as String,
          familyInfo: item['familyInfo'] as String,
          annualIncome: item['annualIncome'] as String,
          car: item['car'] as String,
          house: item['house'] as String,
          maritalStatus: MaritalStatus.values[item['maritalStatus'] as int],
          children: item['children'] as String,
          photoPath: (item['photoPath'] as String?) ?? '',
          selfEvaluation: item['selfEvaluation'] as String,
          partnerRequirements: item['partnerRequirements'] as String,
        );
      }).toList();

      // 检查冲突
      final existingClients = await widget.database.getAllClients();
      final existingIds = existingClients.map((c) => c.clientId).toSet();

      final conflictClients = <String, List<Client>>{};
      final noConflictClients = <Client>[];

      for (var client in importedClients) {
        if (existingIds.contains(client.clientId)) {
          final existing = existingClients.firstWhere((c) => c.clientId == client.clientId);
          conflictClients[client.clientId] = [existing, client];
        } else {
          noConflictClients.add(client);
        }
      }

      // 先导入无冲突的数据
      for (var client in noConflictClients) {
        await widget.database.insertClient(client.toCompanion(true));
      }

      // 如果有冲突，显示冲突解决界面
      if (conflictClients.isNotEmpty && mounted) {
        final resolvedClients = await Navigator.push<List<Client>>(
          context,
          MaterialPageRoute(
            builder: (context) => ConflictResolutionPage(
              conflicts: conflictClients,
            ),
          ),
        );

        if (resolvedClients != null) {
          for (var client in resolvedClients) {
            await widget.database.updateClient(client);
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('成功导入 ${noConflictClients.length + (conflictClients.isEmpty ? 0 : conflictClients.length)} 条数据'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('导入失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 外观设置
            ModernCard(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFD0021B), Color(0xFFF75C5C)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.palette,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '外观',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Consumer<theme_utils.ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _showThemeDialog,
                          borderRadius: BorderRadius.circular(12),
                          splashColor: const Color(0xFFD0021B).withValues(alpha: 0.1),
                          highlightColor: const Color(0xFFD0021B).withValues(alpha: 0.05),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.color_lens,
                                  color: Colors.grey.shade600,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    '主题模式',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  themeProvider.getThemeModeLabel(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey.shade400,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 数据管理
            ModernCard(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFD0021B), Color(0xFFF75C5C)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.storage,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '数据管理',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GradientButton(
                          onPressed: _exportData,
                          height: 60,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file, color: Colors.white, size: 16),
                              SizedBox(width: 6),
                              Text(
                                '导出数据',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GradientButton(
                          onPressed: _importData,
                          height: 60,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.download, color: Colors.white, size: 16),
                              SizedBox(width: 6),
                              Text(
                                '导入数据',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 应用信息
            ModernCard(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFD0021B), Color(0xFFF75C5C)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '关于',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutPage(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      splashColor: const Color(0xFFD0021B).withValues(alpha: 0.1),
                      highlightColor: const Color(0xFFD0021B).withValues(alpha: 0.05),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Icon(Icons.favorite, color: Color(0xFFD0021B), size: 16),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '姻缘册',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '版本 1.1.0',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey.shade400,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 冲突解决页面
class ConflictResolutionPage extends StatefulWidget {
  final Map<String, List<Client>> conflicts;

  const ConflictResolutionPage({
    super.key,
    required this.conflicts,
  });

  @override
  State<ConflictResolutionPage> createState() => _ConflictResolutionPageState();
}

class _ConflictResolutionPageState extends State<ConflictResolutionPage> {
  int _currentIndex = 0;
  final List<Client> _resolvedClients = [];
  late List<String> _conflictIds;

  @override
  void initState() {
    super.initState();
    _conflictIds = widget.conflicts.keys.toList();
  }

  void _selectClient(Client client) {
    _resolvedClients.add(client);

    if (_currentIndex < _conflictIds.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // 所有冲突已解决
      Navigator.pop(context, _resolvedClients);
    }
  }

  int _calculateAge(int birthYear) {
    final currentYear = DateTime.now().year;
    return currentYear - birthYear;
  }

  @override
  Widget build(BuildContext context) {
    final currentId = _conflictIds[_currentIndex];
    final clients = widget.conflicts[currentId]!;
    final existing = clients[0];
    final imported = clients[1];

    return Scaffold(
      appBar: AppBar(
        title: Text('解决冲突 ${_currentIndex + 1}/${_conflictIds.length}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '发现相同客户编号的数据，请选择要保留的版本',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 现有数据卡片
                Expanded(
                  child: _buildClientCard(
                    context,
                    existing,
                    '现有数据',
                    Colors.blue,
                    () => _selectClient(existing),
                  ),
                ),
                const SizedBox(width: 16),
                // 导入数据卡片
                Expanded(
                  child: _buildClientCard(
                    context,
                    imported,
                    '导入数据',
                    Colors.green,
                    () => _selectClient(imported),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientCard(
    BuildContext context,
    Client client,
    String label,
    Color color,
    VoidCallback onSelect,
  ) {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('客户编号', client.clientId),
                _buildInfoRow('推荐人', client.recommender),
                _buildInfoRow('性别', client.gender.label),
                _buildInfoRow('年龄', '${_calculateAge(client.birthYear)}岁 (${client.birthYear}年出生)'),
                _buildInfoRow('出生地', client.birthPlace),
                _buildInfoRow('现居地', client.residence),
                _buildInfoRow('身高', '${client.height}cm'),
                _buildInfoRow('体重', '${client.weight}斤'),
                _buildInfoRow('学历', client.education.label),
                _buildInfoRow('职业', client.occupation),
                _buildInfoRow('家庭情况', client.familyInfo),
                _buildInfoRow('年收入', client.annualIncome),
                _buildInfoRow('车', client.car),
                _buildInfoRow('房', client.house),
                _buildInfoRow('婚姻状态', client.maritalStatus.label),
                _buildInfoRow('有无小孩', client.children),
                if (client.selfEvaluation.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text('自我评价:', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(client.selfEvaluation, style: const TextStyle(fontSize: 13)),
                ],
                if (client.partnerRequirements.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text('择偶要求:', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(client.partnerRequirements, style: const TextStyle(fontSize: 13)),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onSelect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('选择此版本'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '--' : value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
