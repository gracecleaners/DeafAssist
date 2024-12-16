import 'package:flutter/material.dart';

class AppMaintenanceSection extends StatelessWidget {
  void _clearAppCache() {
    // Implement cache clearing logic
    // Could use packages like path_provider to clear temporary directories
  }

  void _resetToDefaultSettings() {
    // Reset all settings to default values
    // Clear SharedPreferences or reset to predefined defaults
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Clear App Cache'),
          subtitle: const Text('Free up storage space'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _clearAppCache,
          ),
        ),
        ListTile(
          title: const Text('Reset to Default Settings'),
          subtitle: const Text('Restore all settings to original state'),
          trailing: IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset Settings'),
                  content: const Text('Are you sure you want to reset all settings?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: const Text('Reset'),
                      onPressed: _resetToDefaultSettings,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}