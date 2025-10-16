import 'package:flutter/material.dart';
import '../database/database.dart';
import '../database/client.dart';
import 'client_edit_page.dart';

class ClientDetailPage extends StatefulWidget {
  final AppDatabase database;
  final String clientId;

  const ClientDetailPage({
    super.key,
    required this.database,
    required this.clientId,
  });

  @override
  State<ClientDetailPage> createState() => _ClientDetailPageState();
}

class _ClientDetailPageState extends State<ClientDetailPage> {
  Client? _client;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClient();
  }

  Future<void> _loadClient() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final client = await widget.database.getClientById(widget.clientId);
      setState(() {
        _client = client;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败: $e')),
        );
      }
    }
  }

  Future<void> _deleteClient() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这个客户吗？此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await widget.database.deleteClient(widget.clientId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('客户已删除'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // 返回并刷新列表
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('删除失败: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _editClient() async {
    if (_client == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientEditPage(
          database: widget.database,
          client: _client!,
        ),
      ),
    );

    if (result == true) {
      // 重新加载客户数据
      _loadClient();
    }
  }

  int _calculateAge(int birthYear) {
    final currentYear = DateTime.now().year;
    return currentYear - birthYear;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('客户详情'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _deleteClient,
            icon: const Icon(Icons.delete),
            tooltip: '删除',
            color: Colors.red,
          ),
          IconButton(
            onPressed: _editClient,
            icon: const Icon(Icons.edit),
            tooltip: '编辑',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _client == null
              ? const Center(
                  child: Text(
                    '未找到客户信息',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final isLandscape = constraints.maxWidth >= 900;
                    
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 头部信息卡片
                          Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '客户编号: ${_client!.clientId}',
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.onPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _client!.gender == Gender.male
                                              ? Colors.blue[100]
                                              : Colors.pink[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          _client!.gender.label,
                                          style: TextStyle(
                                            color: _client!.gender == Gender.male
                                                ? Colors.blue[800]
                                                : Colors.pink[800],
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // 根据横竖屏调整布局
                          if (isLandscape)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 左侧：基本信息
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '基本信息',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              _buildInfoRow('推荐人', _client!.recommender),
                                              _buildInfoRow('年龄',
                                                  '${_calculateAge(_client!.birthYear)}岁 (${_client!.birthYear}年出生)'),
                                              _buildInfoRow('出生地', _client!.birthPlace),
                                              _buildInfoRow('现居地', _client!.residence),
                                              _buildInfoRow('身高',
                                                  '${_client!.height == 0 ? '--' : '${_client!.height}cm'}'),
                                              _buildInfoRow('体重',
                                                  '${_client!.weight == 0 ? '--' : '${_client!.weight}斤'}'),
                                              _buildInfoRow('学历', _client!.education.label),
                                              _buildInfoRow('职业', _client!.occupation),
                                              _buildInfoRow('婚姻状态', _client!.maritalStatus.label),
                                              _buildInfoRow('有无小孩', _client!.children),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // 右侧：经济状况、家庭情况、自我评价、择偶要求
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 经济状况
                                      const Text(
                                        '经济状况',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              _buildInfoRow('年收入', _client!.annualIncome),
                                              _buildInfoRow('车', _client!.car),
                                              _buildInfoRow('房', _client!.house),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      // 家庭情况
                                      const Text(
                                        '家庭情况',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _client!.familyInfo.isEmpty
                                                    ? '--'
                                                    : _client!.familyInfo,
                                                style: const TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      // 自我评价
                                      const Text(
                                        '自我评价',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _client!.selfEvaluation.isEmpty
                                                    ? '--'
                                                    : _client!.selfEvaluation,
                                                style: const TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      // 择偶要求
                                      const Text(
                                        '择偶要求',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _client!.partnerRequirements.isEmpty
                                                    ? '--'
                                                    : _client!.partnerRequirements,
                                                style: const TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          else
                            // 竖屏：保持原有布局
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 基本信息
                                const Text(
                                  '基本信息',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        _buildInfoRow('推荐人', _client!.recommender),
                                        _buildInfoRow('年龄',
                                            '${_calculateAge(_client!.birthYear)}岁 (${_client!.birthYear}年出生)'),
                                        _buildInfoRow('出生地', _client!.birthPlace),
                                        _buildInfoRow('现居地', _client!.residence),
                                        _buildInfoRow('身高',
                                            '${_client!.height == 0 ? '--' : '${_client!.height}cm'}'),
                                        _buildInfoRow('体重',
                                            '${_client!.weight == 0 ? '--' : '${_client!.weight}斤'}'),
                                        _buildInfoRow('学历', _client!.education.label),
                                        _buildInfoRow('职业', _client!.occupation),
                                        _buildInfoRow('婚姻状态', _client!.maritalStatus.label),
                                        _buildInfoRow('有无小孩', _client!.children),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // 经济状况
                                const Text(
                                  '经济状况',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        _buildInfoRow('年收入', _client!.annualIncome),
                                        _buildInfoRow('车', _client!.car),
                                        _buildInfoRow('房', _client!.house),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // 家庭情况
                                const Text(
                                  '家庭情况',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _client!.familyInfo.isEmpty
                                              ? '--'
                                              : _client!.familyInfo,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // 自我评价
                                const Text(
                                  '自我评价',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _client!.selfEvaluation.isEmpty
                                              ? '--'
                                              : _client!.selfEvaluation,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // 择偶要求
                                const Text(
                                  '择偶要求',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _client!.partnerRequirements.isEmpty
                                              ? '--'
                                              : _client!.partnerRequirements,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '--' : value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
