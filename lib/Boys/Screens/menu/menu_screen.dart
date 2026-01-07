import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import 'widgets/menu_header.dart';
import 'widgets/menu_tile.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Menu'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const MenuHeader(),
          AppSpacing.h12,
          MenuTile(
            icon: Icons.person_outline,
            title: 'Profile',
            onTap: () {
              // Navigator.push(...)
            },
          ),
          MenuTile(
            icon: Icons.receipt_long_outlined,
            title: 'Payment Report',
            onTap: () {
              // Navigator.push(...)
            },
          ),
        ],
      ),
    );
  }
}
