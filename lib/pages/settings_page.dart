import 'package:flutter/material.dart';

import '../theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Dark mode',style: TextStyle(fontSize: 18)),
            Switch(
              value: themeNotifier.currentTheme == ThemeMode.dark,
              onChanged: (_) => themeNotifier.toggleTheme(),
            )
          ],
        ),
      ),
    );
  }
}
