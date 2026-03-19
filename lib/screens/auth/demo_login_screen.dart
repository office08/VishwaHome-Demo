import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../data/demo_auth.dart';

class DemoLoginScreen extends StatelessWidget {
  const DemoLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF063333), Color(0xFF0D6E6E)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            const SizedBox(height: 32),
            // Logo
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
              ),
              child: const Icon(Icons.apartment_rounded, color: Colors.white, size: 44),
            ),
            const SizedBox(height: 16),
            Text('VishwaHome', style: GoogleFonts.sora(
              fontSize: 30, fontWeight: FontWeight.w800,
              color: Colors.white, letterSpacing: -0.5)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(20)),
              child: Text('🎮  DEMO MODE', style: GoogleFonts.sora(
                fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
            const SizedBox(height: 8),
            Text('Tap any role to explore the app',
              style: GoogleFonts.nunito(
                fontSize: 14, color: Colors.white.withOpacity(0.7))),

            const SizedBox(height: 24),

            // Role cards
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Text('Choose a demo account',
                      style: GoogleFonts.sora(
                        fontSize: 16, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    Text('No OTP, no signup — just tap and explore',
                      style: GoogleFonts.nunito(
                        fontSize: 13, color: AppColors.textHint)),
                    const SizedBox(height: 20),

                    // Role cards
                    _RoleCard(
                      user: MockData.superAdmin,
                      title: 'Super Admin',
                      subtitle: 'Vikram Mehta',
                      description: 'Manage all societies, approve settlements,\ncontrol feature flags, web dashboard',
                      icon: Icons.admin_panel_settings,
                      color: AppColors.superAdminColor,
                      features: ['All societies overview', 'Feature flag control',
                        'Settlement approvals', 'Web dashboard'],
                    ),
                    const SizedBox(height: 12),
                    _RoleCard(
                      user: MockData.admin,
                      title: 'Society Admin',
                      subtitle: 'Priya Sharma — Flat A-001',
                      description: 'Manage bills, expenses, complaints,\nspecial funds, committee, parking',
                      icon: Icons.manage_accounts,
                      color: AppColors.primary,
                      features: ['Bill management', 'Finance dashboard',
                        'Special fund creation', 'Defaulter tracking'],
                    ),
                    const SizedBox(height: 12),
                    _RoleCard(
                      user: MockData.resident,
                      title: 'Resident',
                      subtitle: 'Rajesh Kumar — Flat A-304',
                      description: 'Pay maintenance, view expenses,\nvote on polls, raise complaints',
                      icon: Icons.home_rounded,
                      color: AppColors.teal,
                      features: ['View & pay bills', 'Society finances',
                        'Vote on polls', 'Special fund'],
                    ),
                    const SizedBox(height: 12),
                    _RoleCard(
                      user: MockData.guard,
                      title: 'Security Guard',
                      subtitle: 'Ramu Watchman',
                      description: 'Log visitors and deliveries,\ntrack entry/exit',
                      icon: Icons.security,
                      color: const Color(0xFF784212),
                      features: ['Log visitor', 'Log delivery',
                        'View today\'s log', 'Visitor history'],
                    ),

                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(children: [
                        const Icon(Icons.info_outline,
                            size: 16, color: AppColors.textHint),
                        const SizedBox(width: 10),
                        Expanded(child: Text(
                          'Demo data is pre-loaded. Payments show the UI flow but '
                          'no real transactions are processed.',
                          style: GoogleFonts.nunito(
                              fontSize: 12, color: AppColors.textSecondary,
                              height: 1.4),
                        )),
                      ]),
                    ),
                    const SizedBox(height: 12),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final DemoUser user;
  final String title, subtitle, description;
  final IconData icon;
  final Color color;
  final List<String> features;

  const _RoleCard({
    required this.user, required this.title, required this.subtitle,
    required this.description, required this.icon, required this.color,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<DemoAuthProvider>().login(user),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.25)),
          boxShadow: [BoxShadow(
            color: color.withOpacity(0.08), blurRadius: 12,
            offset: const Offset(0, 4))],
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Icon
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(title, style: GoogleFonts.sora(
                fontSize: 15, fontWeight: FontWeight.w800, color: color)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(20)),
                child: Text('Enter →', style: GoogleFonts.sora(
                  fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ]),
            const SizedBox(height: 2),
            Text(subtitle, style: GoogleFonts.nunito(
              fontSize: 12, color: AppColors.textSecondary,
              fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(description, style: GoogleFonts.nunito(
              fontSize: 12, color: AppColors.textHint, height: 1.4)),
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 4, children: features.map((f) =>
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6)),
                child: Text(f, style: GoogleFonts.sora(
                  fontSize: 10, fontWeight: FontWeight.w600,
                  color: color)),
              ),
            ).toList()),
          ])),
        ]),
      ),
    );
  }
}
