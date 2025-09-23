import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/app/providers.dart';
import 'package:time_tracker/data/repositories/settings_repository.dart';

class SettingsDialog extends ConsumerStatefulWidget {
  const SettingsDialog({super.key});

  @override
  ConsumerState<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends ConsumerState<SettingsDialog> {
  final TextEditingController _breakLabelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = await ref.read(settingsProvider.future);
    if (!mounted) return;
    _breakLabelController.text = settings.defaultBreakLabel;
  }

  @override
  void dispose() {
    _breakLabelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saving = ValueNotifier<bool>(false);
    return AlertDialog(
      title: const Text('Settings'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _breakLabelController,
              decoration: const InputDecoration(
                labelText: 'Default break label',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: const Text('Cancel'),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: saving,
          builder: (context, isSaving, _) {
            return FilledButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      saving.value = true;
                      try {
                        final repo = ref.read(settingsRepositoryProvider);
                        final current = await ref.read(settingsProvider.future);
                        final updated = current.copyWith(
                          defaultBreakLabel:
                              _breakLabelController.text.trim().isEmpty
                              ? Settings.defaults.defaultBreakLabel
                              : _breakLabelController.text.trim(),
                        );
                        await repo.save(updated);
                        // Invalidate settings provider so listeners refresh
                        ref.invalidate(settingsProvider);
                        if (mounted) Navigator.of(context).maybePop();
                      } finally {
                        saving.value = false;
                      }
                    },
              child: const Text('Save'),
            );
          },
        ),
      ],
    );
  }
}
