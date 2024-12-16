import 'package:flutter/material.dart';

class NotificationSettingsSection extends StatefulWidget {
  @override
  _NotificationSettingsSectionState createState() => _NotificationSettingsSectionState();
}

class _NotificationSettingsSectionState extends State<NotificationSettingsSection> {
  Map<String, bool> _notificationPreferences = {
    'Email Notifications': true,
    'Push Notifications': true,
    'SMS Alerts': false,
    'Marketing Communications': false,
  };

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Notification Preferences'),
      children: _notificationPreferences.keys.map((String key) {
        return SwitchListTile(
          title: Text(key),
          value: _notificationPreferences[key]!,
          onChanged: (bool value) {
            setState(() {
              _notificationPreferences[key] = value;
            });
          },
        );
      }).toList(),
    );
  }
}