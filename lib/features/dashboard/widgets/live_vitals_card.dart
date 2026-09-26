import 'package:flutter/material.dart';

import '../../../core/dashboard_theme.dart';
import '../../../data/models/vitals.dart';

/// 2x2 vitals grid built from two Rows of two Expanded tiles each — not
/// GridView. Expanded guarantees each tile gets exactly half the available
/// width regardless of screen size, so this can't overflow.
class LiveVitalsCard extends StatelessWidget {
  const LiveVitalsCard({super.key, required this.vitals});

  final Vitals vitals;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitleRow(
            title: 'Live Vitals',
            trailingLabel: 'Live',
            dotColor: ParaCareColors.stable,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _VitalTile(
                  icon: Icons.water_drop,
                  value: '${vitals.spo2Percent.toStringAsFixed(0)}%',
                  label: 'SpO₂',
                  color: const Color(0xFF0EA5E9),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _VitalTile(
                  icon: Icons.favorite,
                  value: '${vitals.heartRateBpm} bpm',
                  label: 'Heart Rate',
                  color: ParaCareColors.critical,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _VitalTile(
                  icon: Icons.air,
                  value: '${vitals.respirationRpm} rpm',
                  label: 'Respiration',
                  color: ParaCareColors.cyan,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _VitalTile(
                  icon: Icons.thermostat,
                  value: '${vitals.temperatureCelsius.toStringAsFixed(1)}°C',
                  label: 'Temperature',
                  color: ParaCareColors.attention,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VitalTile extends StatelessWidget {
  const _VitalTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: ParaCareColors.ink,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10.5, color: ParaCareColors.muted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}