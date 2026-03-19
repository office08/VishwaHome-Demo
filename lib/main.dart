import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'data/demo_auth.dart';
import 'data/mock_data.dart';
import 'screens/auth/demo_login_screen.dart';
import 'screens/resident/demo_resident_dashboard.dart';
import 'screens/admin/demo_admin_dashboard.dart';
import 'screens/guard/demo_guard_dashboard.dart';
import 'screens/superadmin/demo_superadmin_dashboard.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DemoAuthProvider(),
      child: const VishwaHomeDemoApp(),
    ),
  );
}

class VishwaHomeDemoApp extends StatelessWidget {
  const VishwaHomeDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VishwaHome Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Show a prominent DEMO banner
      builder: (context, child) => Stack(children: [
        child!,
        // Demo watermark banner
        Positioned(
          top: 0, left: 0, right: 0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              color: const Color(0xFFE8841A),
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: const Text(
                '🎮  DEMO MODE — All data is sample only. No real payments or accounts.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11, color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ]),
      home: const DemoRoleGate(),
    );
  }
}

/// Decides which screen to show based on demo login state
class DemoRoleGate extends StatelessWidget {
  const DemoRoleGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<DemoAuthProvider>();
    if (!auth.isLoggedIn) return const DemoLoginScreen();

    switch (auth.currentUser!.role) {
      case 'super_admin':   return const DemoSuperAdminDashboard();
      case 'society_admin': return const DemoAdminDashboard();
      case 'resident':      return const DemoResidentDashboard();
      case 'guard':         return const DemoGuardDashboard();
      default:              return const DemoLoginScreen();
    }
  }
}
