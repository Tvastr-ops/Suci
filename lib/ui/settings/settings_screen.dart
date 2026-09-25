import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/services/backup_service.dart';
import '../../domain/enums/progress_unit.dart';
import '../../providers/database_provider.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final backupService = ref.watch(backupServiceProvider);
    final workRepo = ref.watch(workRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Section: Appearance
          _buildSectionHeader(context, 'Appearance'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_6_rounded),
                  title: const Text('Theme Mode'),
                  trailing: DropdownButton<ThemeMode>(
                    value: settings.themeMode,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('System'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark'),
                      ),
                    ],
                    onChanged: (mode) {
                      if (mode != null) {
                        settingsNotifier.setThemeMode(mode);
                      }
                    },
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.palette_outlined),
                  title: const Text('Dynamic Color'),
                  subtitle: const Text('Use wallpaper palette on Android 12+'),
                  value: settings.dynamicColor,
                  onChanged: (val) {
                    settingsNotifier.setDynamicColor(val);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.format_list_numbered_rounded),
                  title: const Text('Default Progress Unit'),
                  subtitle: Text(settings.defaultProgressUnit.label),
                  trailing: DropdownButton<ProgressUnit>(
                    value: settings.defaultProgressUnit,
                    underline: const SizedBox(),
                    items: ProgressUnit.values.map((u) {
                      return DropdownMenuItem(
                        value: u,
                        child: Text(u.label),
                      );
                    }).toList(),
                    onChanged: (unit) {
                      if (unit != null) {
                        settingsNotifier.setDefaultProgressUnit(unit);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section: Backup & Portability
          _buildSectionHeader(context, 'Backup & Portability (Local-First)'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.upload_file_rounded),
                  title: const Text('Export Library (JSON)'),
                  subtitle: const Text(
                      'Save or share structured backup of all works, tags & logs'),
                  onTap: () => _exportJson(context, backupService),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.table_chart_outlined),
                  title: const Text('Export to Spreadsheet (CSV)'),
                  subtitle: const Text(
                      'Tabular export for Google Sheets or Excel'),
                  onTap: () => _exportCsv(context, backupService),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.archive_outlined),
                  title: const Text('Export Full Archive (.ZIP)'),
                  subtitle: const Text('Includes library data and cover images'),
                  onTap: () => _exportZip(context, backupService),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.download_rounded),
                  title: const Text('Import / Restore Backup'),
                  subtitle: const Text(
                      'Restore from JSON backup with merge or overwrite'),
                  onTap: () => _importBackup(context, backupService),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section: Danger Zone
          _buildSectionHeader(context, 'Data Reset'),
          Card(
            color: colorScheme.errorContainer.withValues(alpha: 0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                  color: colorScheme.error.withValues(alpha: 0.4)),
            ),
            child: ListTile(
              leading: Icon(Icons.delete_forever_rounded,
                  color: colorScheme.error),
              title: Text(
                'Clear All Data',
                style: TextStyle(
                    color: colorScheme.error, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                  'Permanently delete all works, tags, and progress logs'),
              onTap: () => _confirmClearAll(context, workRepo),
            ),
          ),
          const SizedBox(height: 24),

          // About
          Center(
            child: Column(
              children: [
                Text(
                  'Suci v1.0.0',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Offline, local-first literature & web serial tracker',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Future<void> _exportJson(
      BuildContext context, BackupService backupService) async {
    try {
      final jsonStr = await backupService.exportToJson();
      final tempDir = await getTemporaryDirectory();
      final dateStr = DateTime.now().toIso8601String().split('T').first;
      final file = File(p.join(tempDir.path, 'suci_backup_$dateStr.json'));
      await file.writeAsString(jsonStr);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'Suci Library Backup',
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  Future<void> _exportCsv(
      BuildContext context, BackupService backupService) async {
    try {
      final csvStr = await backupService.exportToCsv();
      final tempDir = await getTemporaryDirectory();
      final dateStr = DateTime.now().toIso8601String().split('T').first;
      final file = File(p.join(tempDir.path, 'suci_library_$dateStr.csv'));
      await file.writeAsString(csvStr);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'Suci Library CSV',
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CSV Export failed: $e')),
        );
      }
    }
  }

  Future<void> _exportZip(
      BuildContext context, BackupService backupService) async {
    try {
      final file = await backupService.exportToZip();
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'Suci Full Archive',
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Archive Export failed: $e')),
        );
      }
    }
  }

  Future<void> _importBackup(
      BuildContext context, BackupService backupService) async {
    try {
      final picked = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (picked == null || picked.path == null) return;

      final file = File(picked.path!);
      final jsonStr = await file.readAsString();
      final preview = backupService.parseAndValidateJson(jsonStr);

      if (!context.mounted) return;

      bool overwrite = false;

      final shouldProceed = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('Import Backup'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Found in backup:'),
                    const SizedBox(height: 6),
                    Text('• ${preview.workCount} works'),
                    Text('• ${preview.tagCount} tags'),
                    Text('• ${preview.progressLogCount} progress logs'),
                    const SizedBox(height: 16),
                    const Text('Import Mode:'),
                    const SizedBox(height: 8),
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        overwrite ? Icons.circle_outlined : Icons.radio_button_checked,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text('Merge (Recommended)'),
                      subtitle: const Text('Keep local works, update with newer'),
                      onTap: () => setDialogState(() => overwrite = false),
                    ),
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        overwrite ? Icons.radio_button_checked : Icons.circle_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text('Overwrite'),
                      subtitle: const Text('Wipe local database and replace'),
                      onTap: () => setDialogState(() => overwrite = true),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Import'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (shouldProceed == true) {
        await backupService.importBackup(
          preview.rawData,
          overwrite: overwrite,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Successfully imported ${preview.workCount} works (${overwrite ? 'Overwritten' : 'Merged'})!'),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import error: $e')),
        );
      }
    }
  }

  void _confirmClearAll(BuildContext context, dynamic workRepo) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete ALL Library Data?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This will permanently delete all works, tags, and progress logs from your device. This cannot be undone.',
                style: TextStyle(color: Colors.redAccent),
              ),
              const SizedBox(height: 12),
              const Text('Type DELETE to confirm:'),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'DELETE',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () async {
                if (controller.text.trim() == 'DELETE') {
                  await workRepo.clearAllData();
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All data has been cleared.')),
                    );
                  }
                }
              },
              child: const Text('Clear All Data'),
            ),
          ],
        );
      },
    );
  }
}
