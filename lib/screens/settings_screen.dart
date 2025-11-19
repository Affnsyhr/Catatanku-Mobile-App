import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProv, _) {
          final isDark = themeProv.themeMode == ThemeMode.dark;
          return ListView(
            children: [
              ListTile(
                title: const Text('Mode Gelap'),
                subtitle: const Text(
                  'Aktifkan mode gelap untuk pengalaman visual yang lebih nyaman',
                ),
                trailing: Switch(
                  value: isDark,
                  onChanged: (v) {
                    try {
                      themeProv.toggleDarkMode(v);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            v ? 'Mode gelap aktif' : 'Mode terang aktif',
                          ),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gagal mengubah tema: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text('Tentang Aplikasi'),
                subtitle: const Text('Notes App v1.0.0'),
                leading: const Icon(Icons.info),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Notes App',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2025 Catatan Pribadi',
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          'Aplikasi untuk menyimpan catatan pribadi dengan mudah. Gunakan fitur ini untuk mencatat hal-hal penting Anda.',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
