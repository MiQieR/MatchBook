import 'package:flutter/material.dart';
import '../database/database.dart';
import '../database/client.dart';
import 'client_detail_page.dart';

class SearchPage extends StatefulWidget {
  final AppDatabase database;

  const SearchPage({super.key, required this.database});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _keywordController = TextEditingController();
  final _minBirthYearController = TextEditingController();
  final _maxBirthYearController = TextEditingController();
  final _minHeightController = TextEditingController();
  final _maxHeightController = TextEditingController();
  final _minWeightController = TextEditingController();
  final _maxWeightController = TextEditingController();
  final _occupationController = TextEditingController();
  final _residenceController = TextEditingController();

  final Set<Gender> _selectedGenders = {};
  Education? _selectedEducation;
  final Set<MaritalStatus> _selectedMaritalStatuses = {};
  List<Client> _searchResults = [];
  bool _isSearching = false;
  bool _showAdvancedFilters = false;

  @override
  void dispose() {
    _keywordController.dispose();
    _minBirthYearController.dispose();
    _maxBirthYearController.dispose();
    _minHeightController.dispose();
    _maxHeightController.dispose();
    _minWeightController.dispose();
    _maxWeightController.dispose();
    _occupationController.dispose();
    _residenceController.dispose();
    super.dispose();
  }

  Future<void> _searchClients() async {
    setState(() {
      _isSearching = true;
    });

    try {
      final results = await widget.database.searchClients(
        keyword: _keywordController.text.isNotEmpty ? _keywordController.text : null,
        genders: _selectedGenders.isNotEmpty ? _selectedGenders.toList() : null,
        minBirthYear: _minBirthYearController.text.isNotEmpty
            ? int.tryParse(_minBirthYearController.text) : null,
        maxBirthYear: _maxBirthYearController.text.isNotEmpty
            ? int.tryParse(_maxBirthYearController.text) : null,
        minHeight: _minHeightController.text.isNotEmpty
            ? int.tryParse(_minHeightController.text) : null,
        maxHeight: _maxHeightController.text.isNotEmpty
            ? int.tryParse(_maxHeightController.text) : null,
        minWeight: _minWeightController.text.isNotEmpty
            ? int.tryParse(_minWeightController.text) : null,
        maxWeight: _maxWeightController.text.isNotEmpty
            ? int.tryParse(_maxWeightController.text) : null,
        educations: _selectedEducation != null ? [_selectedEducation!] : null,
        occupation: _occupationController.text.isNotEmpty ? _occupationController.text : null,
        residence: _residenceController.text.isNotEmpty ? _residenceController.text : null,
        maritalStatuses: _selectedMaritalStatuses.isNotEmpty ? _selectedMaritalStatuses.toList() : null,
      );

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('搜索失败: $e')),
        );
      }
    }
  }

  void _resetFilters() {
    setState(() {
      _keywordController.clear();
      _minBirthYearController.clear();
      _maxBirthYearController.clear();
      _minHeightController.clear();
      _maxHeightController.clear();
      _minWeightController.clear();
      _maxWeightController.clear();
      _occupationController.clear();
      _residenceController.clear();
      _selectedGenders.clear();
      _selectedEducation = null;
      _selectedMaritalStatuses.clear();
      _searchResults.clear();
    });
  }

  int _calculateAge(int birthYear) {
    final currentYear = DateTime.now().year;
    return currentYear - birthYear;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('查询客户'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 统一搜索框
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.blue[50],
              child: Column(
                children: [
                  TextField(
                    controller: _keywordController,
                    decoration: InputDecoration(
                      hintText: '搜索客户编号、推荐人、自我评价、择偶要求等...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onSubmitted: (value) => _searchClients(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isSearching ? null : _searchClients,
                          icon: _isSearching
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.search),
                          label: Text(_isSearching ? '查询中...' : '查询'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _resetFilters,
                          icon: const Icon(Icons.clear_all),
                          label: const Text('重置'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _showAdvancedFilters = !_showAdvancedFilters;
                          });
                        },
                        icon: Icon(_showAdvancedFilters ? Icons.expand_less : Icons.expand_more),
                        tooltip: '高级筛选',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 高级筛选区域
            if (_showAdvancedFilters)
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('高级筛选', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildGenderFilter()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildEducationDropdown()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildRangeField('出生年份', _minBirthYearController, _maxBirthYearController)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildRangeField('身高(cm)', _minHeightController, _maxHeightController)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildRangeField('体重(斤)', _minWeightController, _maxWeightController),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _occupationController,
                            decoration: const InputDecoration(
                              labelText: '职业关键词',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _residenceController,
                            decoration: const InputDecoration(
                              labelText: '居住地关键词',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildMaritalStatusFilter(),
                  ],
                ),
              ),
            if (_searchResults.isNotEmpty)
              ...(_searchResults.map((client) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    child: _buildClientCard(client),
                  )).toList())
            else
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  '未找到匹配的客户',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('性别', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: Gender.values.map((gender) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: _selectedGenders.contains(gender),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedGenders.add(gender);
                      } else {
                        _selectedGenders.remove(gender);
                      }
                    });
                  },
                ),
                Text(gender.label),
                const SizedBox(width: 16),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEducationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('学历', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        DropdownButtonFormField<Education>(
          decoration: const InputDecoration(
            hintText: '选择学历',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          items: [
            const DropdownMenuItem<Education>(
              value: null,
              child: Text('不限'),
            ),
            ...Education.values.map((Education education) {
              return DropdownMenuItem<Education>(
                value: education,
                child: Text(education.label),
              );
            }),
          ],
          onChanged: (Education? value) {
            setState(() {
              _selectedEducation = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildMaritalStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('婚姻状态', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          children: MaritalStatus.values.map((status) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: _selectedMaritalStatuses.contains(status),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedMaritalStatuses.add(status);
                      } else {
                        _selectedMaritalStatuses.remove(status);
                      }
                    });
                  },
                ),
                Text(status.label),
                const SizedBox(width: 8),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRangeField(String label, TextEditingController minController, TextEditingController maxController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: minController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '最小值',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('—'),
            ),
            Expanded(
              child: TextField(
                controller: maxController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '最大值',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildClientCard(Client client) {
    final age = _calculateAge(client.birthYear);

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {
          // 导航到客户详情页面
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClientDetailPage(
                database: widget.database,
                clientId: client.clientId,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '客户编号: ${client.clientId}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: client.gender == Gender.male ? Colors.blue[100] : Colors.pink[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      client.gender.label,
                      style: TextStyle(
                        color: client.gender == Gender.male ? Colors.blue[800] : Colors.pink[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow('推荐人', client.recommender),
              _buildInfoRow('年龄', '$age岁 (${client.birthYear}年出生)'),
              _buildInfoRow('出生地', client.birthPlace),
              _buildInfoRow('现居地', client.residence),
              _buildInfoRow('身高体重', '${client.height}cm / ${client.weight}斤'),
              _buildInfoRow('学历', client.education.label),
              _buildInfoRow('职业', client.occupation),
              _buildInfoRow('家庭情况', client.familyInfo),
              _buildInfoRow('年收入', client.annualIncome),
              _buildInfoRow('车', client.car),
              _buildInfoRow('房', client.house),
              _buildInfoRow('婚姻状态', client.maritalStatus.label),
              _buildInfoRow('有无小孩', client.children),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '点击查看详情 >',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
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
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value.isEmpty ? '--' : value),
          ),
        ],
      ),
    );
  }
}