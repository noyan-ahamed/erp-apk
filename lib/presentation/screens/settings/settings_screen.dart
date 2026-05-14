import 'package:enterprise_resource_planning/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
              title: Text(
                "Dark Mode",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                "Toggle application theme",
                style: GoogleFonts.inter(fontSize: 13),
              ),
              trailing: Switch(
                value: isDark,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
