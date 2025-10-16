import 'package:flutter/material.dart';
import '../database/database.dart';
import '../database/client.dart';
import 'client_detail_page.dart';
import '../widgets/modern_card.dart';
import '../widgets/gradient_button.dart';

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

  Gender? _selectedGender;
  Education? _selectedEducation;
  final Set<MaritalStatus> _selectedMaritalStatuses = {};
  List<Client> _searchResults = [];
  bool _isSearching = false;
  bool _showAdvancedFilters = false;
  bool _useFuzzySearch = false; // 模糊搜索(或逻辑)
  bool _hasCar = false; // 有车
  bool _hasHouse = false; // 有房

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
        useFuzzySearch: _useFuzzySearch,
        genders: _selectedGender != null ? [_selectedGender!] : null,
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
        hasCar: _hasCar ? true : null,
        hasHouse: _hasHouse ? true : null,
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
      _selectedGender = null;
      _selectedEducation = null;
      _selectedMaritalStatuses.clear();
      _searchResults.clear();
      _useFuzzySearch = false;
      _hasCar = false;
      _hasHouse = false;
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth >= 900;
          
          return SingleChildScrollView(
            child: Column(
              children: [
                // 统一搜索框
                ModernCard(
              padding: const EdgeInsets.all(20.0),
              child: Column(
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
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '查询客户',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _keywordController,
                    decoration: InputDecoration(
                      hintText: '搜索 编号/推荐人/现居地/职业 等（空格分隔）',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                    onSubmitted: (value) => _searchClients(),
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFFD0021B),
                              width: 1.5,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                            child: InkWell(
                              onTap: _resetFilters,
                              borderRadius: BorderRadius.circular(24),
                              splashColor: const Color(0xFFD0021B).withValues(alpha: 0.1),
                              highlightColor: const Color(0xFFD0021B).withValues(alpha: 0.05),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.clear_all, color: Color(0xFFD0021B), size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      '重置',
                                      style: TextStyle(
                                        color: Color(0xFFD0021B),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GradientButton(
                          onPressed: _isSearching ? null : _searchClients,
                          isLoading: _isSearching,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                _isSearching ? '搜索中...' : '搜索',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _showAdvancedFilters = !_showAdvancedFilters;
                              });
                            },
                            borderRadius: BorderRadius.circular(16),
                            splashColor: Colors.grey.shade300.withValues(alpha: 0.3),
                            highlightColor: Colors.grey.shade300.withValues(alpha: 0.1),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                _showAdvancedFilters ? Icons.expand_less : Icons.expand_more,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // 判断是否为竖屏模式（宽度较小）
                    final isPortrait = constraints.maxWidth < 600;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('高级筛选', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        // 模糊搜索和性别
                        _buildGenderAndFuzzySearchFilter(isPortrait),
                        const SizedBox(height: 12),
                        // 学历和出生年份 - 根据横竖屏调整布局
                        if (isPortrait) ...[
                          // 竖屏：学历独占一行
                          _buildEducationDropdown(),
                          const SizedBox(height: 12),
                          // 竖屏：出生年份独占一行
                          _buildRangeField('出生年份', _minBirthYearController, _maxBirthYearController),
                        ] else ...[
                          // 横屏：学历和出生年份在同一行
                          Row(
                            children: [
                              Expanded(child: _buildEducationDropdown()),
                              const SizedBox(width: 8),
                              Expanded(child: _buildRangeField('出生年份', _minBirthYearController, _maxBirthYearController)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        // 身高和体重筛选 - 根据横竖屏调整布局
                        if (isPortrait) ...[
                          // 竖屏：身高和体重在同一行
                          Row(
                            children: [
                              Expanded(child: _buildRangeField('身高(cm)', _minHeightController, _maxHeightController)),
                              const SizedBox(width: 8),
                              Expanded(child: _buildRangeField('体重(斤)', _minWeightController, _maxWeightController)),
                            ],
                          ),
                        ] else ...[
                          // 横屏：身高和体重在同一行
                          Row(
                            children: [
                              Expanded(child: _buildRangeField('身高(cm)', _minHeightController, _maxHeightController)),
                              const SizedBox(width: 8),
                              Expanded(child: _buildRangeField('体重(斤)', _minWeightController, _maxWeightController)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        // 职业和居住地
                        isPortrait
                            ? Column(
                                children: [
                                  TextField(
                                    controller: _occupationController,
                                    decoration: const InputDecoration(
                                      labelText: '职业关键词',
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _residenceController,
                                    decoration: const InputDecoration(
                                      labelText: '居住地关键词',
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
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
                        // 有车和有房筛选 - 根据横竖屏调整布局
                        if (isPortrait) ...[
                          // 竖屏：有车和有房在婚姻状态上方
                          _buildCarAndHouseFilter(),
                          const SizedBox(height: 12),
                          _buildMaritalStatusFilter(),
                        ] else ...[
                          // 横屏：有车和有房与婚姻状态在同一行
                          Row(
                            children: [
                              Expanded(child: _buildCarAndHouseFilter()),
                              const SizedBox(width: 16),
                              Expanded(child: _buildMaritalStatusFilter()),
                            ],
                          ),
                        ],
                      ],
                    );
                  },
                ),
                ),
                if (_searchResults.isNotEmpty)
                  isLandscape
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _searchResults.map((client) {
                            return SizedBox(
                              width: (constraints.maxWidth - 32 - 24) / 3,
                              child: _buildModernClientCard(client),
                            );
                          }).toList(),
                        ),
                      )
                    : Column(
                        children: _searchResults.map((client) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                          child: _buildModernClientCard(client),
                        )).toList(),
                      )
                else
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '未找到匹配的客户',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenderAndFuzzySearchFilter(bool isPortrait) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (!isPortrait) ...[
              // 横屏：模糊搜索在浅色圆角矩形背景框内（占1/3宽度）
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('模糊搜索', style: TextStyle(fontWeight: FontWeight.w500)),
                      Checkbox(
                        value: _useFuzzySearch,
                        onChanged: (bool? value) {
                          setState(() {
                            _useFuzzySearch = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 120),
              // 性别选项紧跟在背景框右侧
              const Text('性别', style: TextStyle(fontWeight: FontWeight.w500)),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedGender = null;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<Gender?>(
                      value: null,
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                    const Text('不限'),
                  ],
                ),
              ),
              ...Gender.values.map((gender) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedGender = gender;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<Gender?>(
                        value: gender,
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(gender.label),
                    ],
                  ),
                );
              }),
              Expanded(flex: 2, child: Container()), // 占据剩余空间
            ],
            if (isPortrait) ...[
              // 竖屏：保持原样
              const Text('模糊搜索', style: TextStyle(fontWeight: FontWeight.w500)),
              Checkbox(
                value: _useFuzzySearch,
                onChanged: (bool? value) {
                  setState(() {
                    _useFuzzySearch = value ?? false;
                  });
                },
              ),
              const Spacer(),
              const Text('性别', style: TextStyle(fontWeight: FontWeight.w500)),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedGender = null;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<Gender?>(
                      value: null,
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                    const Text('不限'),
                  ],
                ),
              ),
              ...Gender.values.map((gender) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedGender = gender;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<Gender?>(
                        value: gender,
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(gender.label),
                    ],
                  ),
                );
              }),
            ],
          ],
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.black87,
          ),
          items: [
            const DropdownMenuItem<Education>(
              value: null,
              child: Text('不限', style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
            ),
            ...Education.values.map((Education education) {
              return DropdownMenuItem<Education>(
                value: education,
                child: Text(education.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
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

  Widget _buildCarAndHouseFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _hasCar,
              onChanged: (bool? value) {
                setState(() {
                  _hasCar = value ?? false;
                });
              },
            ),
            const Text('有车', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(width: 24),
            Checkbox(
              value: _hasHouse,
              onChanged: (bool? value) {
                setState(() {
                  _hasHouse = value ?? false;
                });
              },
            ),
            const Text('有房', style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildRangeField(String label, TextEditingController minController, TextEditingController maxController) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 判断是否为竖屏模式（宽度较小）
        final isPortrait = constraints.maxWidth < 600;

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
                    decoration: InputDecoration(
                      hintText: isPortrait ? '最小' : '最小值',
                      border: const OutlineInputBorder(),
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
                    decoration: InputDecoration(
                      hintText: isPortrait ? '最大' : '最大值',
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildModernClientCard(Client client) {
    final age = _calculateAge(client.birthYear);

    return ModernCard(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClientDetailPage(
              database: widget.database,
              clientId: client.clientId,
            ),
          ),
        );

        if (result == true && mounted) {
          _searchClients();
        }
      },
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD0021B), Color(0xFFF75C5C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '编号: ${client.clientId}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const Spacer(),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: client.gender == Gender.male
                      ? Colors.blue.shade100
                      : Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  client.gender.label,
                  style: TextStyle(
                    color: client.gender == Gender.male
                        ? Colors.blue.shade800
                        : Colors.pink.shade800,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildModernInfoRow('推荐人', client.recommender),
          _buildModernInfoRow('年龄', '$age岁 (${client.birthYear}年出生)'),
          _buildModernInfoRow('出生地', client.birthPlace),
          _buildModernInfoRow('现居地', client.residence),
          _buildModernInfoRow('身高体重', '${client.height}cm / ${client.weight}斤'),
          _buildModernInfoRow('学历', client.education.label),
          _buildModernInfoRow('职业', client.occupation),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '查看详情',
                style: TextStyle(
                  color: const Color(0xFFD0021B),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                color: const Color(0xFFD0021B),
                size: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '--' : value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}