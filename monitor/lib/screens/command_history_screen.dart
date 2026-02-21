import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monitor/providers/bed_provider.dart';
import 'package:monitor/models/command_model.dart';
import 'package:monitor/utils/colors.dart';

class CommandHistoryScreen extends StatefulWidget {
  final String bedId;

  const CommandHistoryScreen({super.key, required this.bedId});

  @override
  State<CommandHistoryScreen> createState() => _CommandHistoryScreenState();
}

class _CommandHistoryScreenState extends State<CommandHistoryScreen> {
  List<CommandModel> _commands = [];
  bool _isLoading = true;
  String? _filter;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final provider = Provider.of<BedProvider>(context, listen: false);
      final commands = await provider.getBedCommandHistory(widget.bedId);
      setState(() {
        _commands = commands;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  List<CommandModel> get _filteredCommands {
    if (_filter == null || _filter!.isEmpty) return _commands;
    return _commands.where((cmd) {
      final type = cmd.type.toString().split('.').last.toLowerCase();
      return type.contains(_filter!.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Command History'),
        backgroundColor: AppColors.primaryDark,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadHistory),
        ],
      ),
      body: Column(
        children: [
          // Filter Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filter commands...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _filter != null && _filter!.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() => _filter = null);
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() => _filter = value);
              },
            ),
          ),

          // Stats Summary
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildStatChip(
                  'Total',
                  _commands.length.toString(),
                  AppColors.info,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  'Executed',
                  _commands.where((c) => c.isExecuted).length.toString(),
                  AppColors.success,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  'Pending',
                  _commands.where((c) => !c.isExecuted).length.toString(),
                  AppColors.warning,
                ),
              ],
            ),
          ),

          // Command List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCommands.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filteredCommands.length,
                    itemBuilder: (context, index) {
                      final cmd = _filteredCommands[index];
                      return _buildCommandCard(cmd);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommandCard(CommandModel cmd) {
    final isSuccess = cmd.isExecuted;
    final statusColor = isSuccess ? AppColors.success : AppColors.warning;
    final commandType = cmd.type.toString().split('.').last;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _showCommandDetails(cmd),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCommandIcon(commandType),
                  color: statusColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            commandType.replaceAll('_', ' ').toUpperCase(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            cmd.source.toString().split('.').last,
                            style: TextStyle(
                              fontSize: 10,
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${cmd.timestamp.hour.toString().padLeft(2, '0')}:${cmd.timestamp.minute.toString().padLeft(2, '0')} • ${cmd.timestamp.day}/${cmd.timestamp.month}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (cmd.resultMessage != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        cmd.resultMessage!,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSuccess
                              ? AppColors.success
                              : AppColors.danger,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isSuccess ? Icons.check_circle : Icons.access_time,
                color: statusColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No Commands Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _filter != null
                ? 'No commands matching "$_filter"'
                : 'Send commands to see history',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadHistory,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  void _showCommandDetails(CommandModel cmd) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(cmd.type.toString().split('.').last.replaceAll('_', ' ')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Command ID', cmd.id),
            _buildDetailRow('Bed ID', cmd.bedId),
            _buildDetailRow('Source', cmd.source.toString().split('.').last),
            _buildDetailRow(
              'Time',
              '${cmd.timestamp.hour}:${cmd.timestamp.minute}:${cmd.timestamp.second}',
            ),
            _buildDetailRow(
              'Status',
              cmd.isExecuted ? 'Executed' : 'Pending',
              color: cmd.isExecuted ? AppColors.success : AppColors.warning,
            ),
            if (cmd.executedAt != null)
              _buildDetailRow(
                'Executed At',
                '${cmd.executedAt!.hour}:${cmd.executedAt!.minute}',
              ),
            if (cmd.parameters != null && cmd.parameters!.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Parameters:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...cmd.parameters!.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text('${e.key}: ${e.value}'),
                ),
              ),
            ],
            if (cmd.resultMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                'Result: ${cmd.resultMessage}',
                style: TextStyle(
                  color: cmd.isExecuted ? AppColors.success : AppColors.danger,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color ?? AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCommandIcon(String commandType) {
    if (commandType.contains('start')) return Icons.play_arrow;
    if (commandType.contains('stop')) return Icons.stop;
    if (commandType.contains('gate')) return Icons.door_sliding;
    if (commandType.contains('conveyor')) return Icons.sensors;
    if (commandType.contains('mixer')) return Icons.autorenew;
    if (commandType.contains('layer')) return Icons.layers;
    if (commandType.contains('reset')) return Icons.refresh;
    if (commandType.contains('emergency')) return Icons.warning;
    return Icons.code;
  }
}
