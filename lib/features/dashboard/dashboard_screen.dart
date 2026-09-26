import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/mock_dashboard_data.dart';
import 'widgets/bottom_nav.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/detailed_info_button.dart';
import 'widgets/emergency_status_bar.dart';
import 'widgets/live_ecg_card.dart';
import 'widgets/live_vitals_card.dart';
import 'widgets/patient_queue_card.dart';
import 'widgets/patient_summary_card.dart';
import 'widgets/sensor_body_diagram.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      body: SafeArea(
        child: Stack(
          children: [
            // ---------------------------------------------------------
            // FUTURISTIC MEDICAL BACKGROUND
            // ---------------------------------------------------------
            Positioned.fill(
              child: Image.asset(
                'assets/images/paracare_medical_background.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),

            // Soft overlay so the dashboard remains readable.
            Positioned.fill(
              child: Container(
                color: const Color(0xFFEFF6FF).withValues(alpha: 0.38),
              ),
            ),

            // ---------------------------------------------------------
            // DASHBOARD CONTENT
            // ---------------------------------------------------------
            IndexedStack(
              index: _selectedIndex,
              children: const [
                _HomeTab(),

                _PlaceholderTab(
                  icon: Icons.groups_outlined,
                  title: 'Patients',
                ),

                _PlaceholderTab(
                  icon: Icons.monitor_heart_outlined,
                  title: 'Live Monitoring',
                ),

                _PlaceholderTab(
                  icon: Icons.notifications_none,
                  title: 'Alerts',
                ),

                _PlaceholderTab(
                  icon: Icons.more_horiz,
                  title: 'More',
                ),
              ],
            ),
          ],
        ),
      ),

      // ---------------------------------------------------------------
      // BOTTOM NAVIGATION
      // ---------------------------------------------------------------
      bottomNavigationBar: DashboardBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// =====================================================================
// HOME TAB
// =====================================================================

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -----------------------------------------------------------
          // PARA CARE HEADER
          // -----------------------------------------------------------
          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Could not load your account details. '
                    'Check your connection and try again.',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Text(
                  'No role found for this account.',
                );
              }

              final data = snapshot.data!.data();

              final role =
                  data?['role'] as String? ?? 'unknown';

              final displayName =
                  data?['name'] as String? ??
                  user?.email ??
                  'User';

              return DashboardHeader(
                displayName: displayName,
                role: role,
                onLogout: () {
                  FirebaseAuth.instance.signOut();
                },
              );
            },
          ),

          const SizedBox(height: 18),

          // -----------------------------------------------------------
          // PATIENT QUEUE
          // -----------------------------------------------------------
          const PatientQueueCard(
            activeCount: 5,
            totalCount: 48,
            criticalCount: 2,
            attentionCount: 4,
            stableCount: 42,
          ),

          const SizedBox(height: 14),

          // -----------------------------------------------------------
          // SELECTED PATIENT
          // -----------------------------------------------------------
          PatientSummaryCard(
            patient: MockDashboardData.selectedPatient,
          ),

          const SizedBox(height: 14),

          // -----------------------------------------------------------
          // SENSOR NETWORK
          // -----------------------------------------------------------
          SensorBodyDiagram(
            sensors: MockDashboardData.sensors,
          ),

          const SizedBox(height: 14),

          // -----------------------------------------------------------
          // LIVE VITALS
          // -----------------------------------------------------------
          LiveVitalsCard(
            vitals: MockDashboardData.vitals,
          ),

          const SizedBox(height: 14),

          // -----------------------------------------------------------
          // LIVE ECG
          // -----------------------------------------------------------
          const LiveEcgCard(),

          const SizedBox(height: 14),

          // -----------------------------------------------------------
          // EMERGENCY SYSTEM
          // -----------------------------------------------------------
          const EmergencyStatusBar(),

          const SizedBox(height: 14),

          // -----------------------------------------------------------
          // DETAILED INFORMATION
          // -----------------------------------------------------------
          const DetailedInfoButton(),
        ],
      ),
    );
  }
}

// =====================================================================
// PLACEHOLDER TABS
// =====================================================================

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 40,
            color: const Color(0xFF94A3B8),
          ),
          const SizedBox(height: 10),
          Text(
            '$title — coming soon',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}