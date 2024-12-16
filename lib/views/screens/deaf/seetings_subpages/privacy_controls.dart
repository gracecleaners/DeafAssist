import 'package:flutter/material.dart';

class PrivacySettingsSection extends StatefulWidget {
  final Function(bool) onDataSharingChanged;
  
  const PrivacySettingsSection({
    Key? key, 
    required this.onDataSharingChanged
  }) : super(key: key);

  @override
  _PrivacySettingsSectionState createState() => _PrivacySettingsSectionState();
}

class _PrivacySettingsSectionState extends State<PrivacySettingsSection> {
  bool _detailedAnalytics = false;
  bool _crashReporting = true;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Privacy Controls'),
      children: [
        SwitchListTile(
          title: const Text('Detailed Usage Analytics'),
          subtitle: const Text('Help improve app performance'),
          value: _detailedAnalytics,
          onChanged: (bool value) {
            setState(() {
              _detailedAnalytics = value;
              widget.onDataSharingChanged(value);
            });
          },
        ),
        SwitchListTile(
          title: const Text('Crash Reporting'),
          subtitle: const Text('Automatically send crash logs'),
          value: _crashReporting,
          onChanged: (bool value) {
            setState(() {
              _crashReporting = value;
            });
          },
        ),
        TextButton(
          child: const Text('View Privacy Policy'),
          onPressed: _showPrivacyPolicy,
        ),
      ],
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Text(
            'Detailed privacy policy text goes here...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}