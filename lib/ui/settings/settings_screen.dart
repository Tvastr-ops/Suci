import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/services/backup_service.dart';
import '../../domain/enums/progress_unit.dart';
import '../../providers/auth_provider.dart';
import '../../providers/database_provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_theme.dart';
import '../security/pin_setup_dialog.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final authState = ref.watch(authProvider);
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
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
                    alignment: AlignmentDirectional.centerEnd,
                    isDense: true,
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
                  leading: const Icon(Icons.color_lens_outlined),
                  title: const Text('Theme Palette'),
                  subtitle: settings.dynamicColor
                      ? const Text('Active when dynamic color is disabled')
                      : null,
                  trailing: DropdownButton<String>(
                    value: AppPalettes.all.any((p) => p.id == settings.customPalette)
                        ? settings.customPalette
                        : AppPalettes.all.first.id,
                    alignment: AlignmentDirectional.centerEnd,
                    isDense: true,
                    underline: const SizedBox(),
                    items: AppPalettes.all.map((p) {
                      return DropdownMenuItem(
                        value: p.id,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: p.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(p.label),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (id) {
                      if (id != null) {
                        settingsNotifier.setCustomPalette(id);
                      }
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.format_list_numbered_rounded),
                  title: const Text('Default Progress Unit'),
                  trailing: DropdownButton<ProgressUnit>(
                    value: settings.defaultProgressUnit,
                    alignment: AlignmentDirectional.centerEnd,
                    isDense: true,
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

          // Section: Security & Privacy
          _buildSectionHeader(context, 'Security & Privacy'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.lock_outline_rounded),
                  title: const Text('App Lock (Custom PIN)'),
                  subtitle: Text(authState.isLockEnabled
                      ? 'Protected with private 4-digit PIN'
                      : 'Require PIN to open app'),
                  value: authState.isLockEnabled,
                  onChanged: (val) async {
                    if (val) {
                      await PinSetupDialog.show(context);
                    } else {
                      await PinConfirmDisableDialog.show(context);
                    }
                  },
                ),
                if (authState.isLockEnabled) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.pin_outlined),
                    title: const Text('Change PIN'),
                    subtitle: const Text('Update your 4-digit app PIN'),
                    trailing:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () => PinChangeDialog.show(context),
                  ),
                  if (authState.isBiometricAvailable) ...[
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.fingerprint_rounded),
                      title: const Text('Biometric Unlock'),
                      subtitle:
                          const Text('Use fingerprint or face recognition'),
                      value: authState.isBiometricEnabled,
                      onChanged: (val) {
                        ref
                            .read(authProvider.notifier)
                            .setBiometricEnabled(val);
                      },
                    ),
                  ],
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.timer_outlined),
                    title: const Text('Auto-Lock Timeout'),
                    trailing: DropdownButton<int>(
                      value: authState.timeoutSeconds,
                      alignment: AlignmentDirectional.centerEnd,
                      isDense: true,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('Immediately')),
                        DropdownMenuItem(value: 30, child: Text('30 seconds')),
                        DropdownMenuItem(value: 60, child: Text('1 minute')),
                        DropdownMenuItem(value: 300, child: Text('5 minutes')),
                        DropdownMenuItem(value: 900, child: Text('15 minutes')),
                      ],
                      onChanged: (sec) {
                        if (sec != null) {
                          ref
                              .read(authProvider.notifier)
                              .setTimeoutSeconds(sec);
                        }
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section: Backup & Portability
          _buildSectionHeader(context, 'Backup & Portability'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.upload_file_rounded),
                  title: const Text('Export Library'),
                  subtitle: const Text(
                      'Backup as JSON, full ZIP with covers, or CSV'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () => _showExportSheet(context, backupService),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.download_rounded),
                  title: const Text('Import / Restore Backup'),
                  subtitle: const Text(
                      'Restore from JSON backup with merge or overwrite'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14),
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
                  'Sūcī v1.1.5',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Local-first literature & web serial tracker',
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
    ),
  ),
);
  }

  void _showExportSheet(BuildContext context, BackupService backupService) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Export Library',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.data_object_rounded),
                  title: const Text('JSON Backup'),
                  subtitle: const Text(
                      'Recommended • Structured backup for restoring into Suci'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _exportJson(context, backupService);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.archive_outlined),
                  title: const Text('Full Archive (.ZIP)'),
                  subtitle: const Text(
                      'Complete archive including library data and cover images'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _exportZip(context, backupService);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.table_chart_outlined),
                  title: const Text('Spreadsheet (.CSV)'),
                  subtitle: const Text(
                      'Tabular format for viewing in Google Sheets or Excel'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _exportCsv(context, backupService);
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      );
      },
    );
  }


  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
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
