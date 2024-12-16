import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({Key? key}) : super(key: key);

  @override
  _AppSettingsPageState createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  // Settings variables
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  double _textSize = 16.0;
  String _language = 'English';

  // Privacy and Security
  bool _biometricLogin = false;
  bool _dataSharing = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load saved settings from SharedPreferences
  _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      // _darkModeEnabled = prefs.getBool('darkMode') ?? false;
      _textSize = prefs.getDouble('textSize') ?? 16.0;
      _language = prefs.getString('language') ?? 'English';
      _biometricLogin = prefs.getBool('biometricLogin') ?? false;
      _dataSharing = prefs.getBool('dataSharing') ?? true;
    });
  }

  // Save settings to SharedPreferences
  _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setBool('darkMode', _darkModeEnabled);
    await prefs.setDouble('textSize', _textSize);
    await prefs.setString('language', _language);
    await prefs.setBool('biometricLogin', _biometricLogin);
    await prefs.setBool('dataSharing', _dataSharing);
  }

  // Language options
  final List<String> _languageOptions = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Arabic'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _saveSettings();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings Saved')));
            },
          )
        ],
      ),
      body: ListView(
        children: [
          // Notification Settings
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          // Text Size
          ListTile(
            title: const Text('Text Size'),
            subtitle: Slider(
              value: _textSize,
              min: 12.0,
              max: 24.0,
              divisions: 6,
              label: _textSize.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _textSize = value;
                });
              },
            ),
          ),

          // Language Selection
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: _language,
              items: _languageOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _language = newValue!;
                });
              },
            ),
          ),

          // Privacy and Security Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Privacy & Security',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),


          // Data Sharing
          SwitchListTile(
            title: const Text('Allow Data Sharing'),
            subtitle: const Text(
                'Help improve the app by sharing anonymous usage data'),
            value: _dataSharing,
            onChanged: (bool value) {
              setState(() {
                _dataSharing = value;
              });
            },
          ),

          // Account Management
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Account',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          ListTile(
            title: const Text('Manage Account'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _manageAccount,
          ),
        ],
      ),
    );
  }

  // Account Management Method
  void _manageAccount() {
    // Navigation to account management page
    // This would typically involve routing to another page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AccountManagementPage(),
      ),
    );
  }
}

// Placeholder for Account Management Page
class AccountManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: const Text('Manage Account'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Change Password'),
            onTap: () {
              // Implement password change logic
            },
          ),
          ListTile(
            title: const Text('Update Profile'),
            onTap: () {
              // Implement profile update logic
            },
          ),
          ListTile(
            title: const Text('Delete Account'),
            onTap: () {
              // Implement account deletion logic
            },
          ),
        ],
      ),
    );
  }
}
