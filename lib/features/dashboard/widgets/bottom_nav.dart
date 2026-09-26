import 'package:flutter/material.dart';

import '../../../core/dashboard_theme.dart';

/// Note: "Live Monitoring" (reference label) is shortened to "Monitor"
/// here. With 5 tabs on a narrow screen at a small font, that label is a
/// second overflow risk of exactly the same kind as the Patient Queue
/// bug — a long label forced into a fixed-width slot. Shortening it
/// removes the risk without losing meaning.
class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({super.key, required this.currentIndex, this.onTap});

  final int currentIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: ParaCareColors.deepBlue,
      unselectedItemColor: const Color(0xFF94A3B8),
      selectedFontSize: 11,
      unselectedFontSize: 11,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), activeIcon: Icon(Icons.groups), label: 'Patients'),
        BottomNavigationBarItem(icon: Icon(Icons.monitor_heart_outlined), activeIcon: Icon(Icons.monitor_heart), label: 'Monitor'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), activeIcon: Icon(Icons.notifications), label: 'Alerts'),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
      ],
    );
  }
}