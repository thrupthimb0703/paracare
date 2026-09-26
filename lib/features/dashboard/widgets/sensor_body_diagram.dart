import 'package:flutter/material.dart';

import '../../../core/dashboard_theme.dart';
import '../../../data/models/vitals.dart';

/// Centered body silhouette with sensor badges wrapped below it. The
/// reference screenshot puts sensor labels in two side columns flanking
/// the body — that layout doesn't fit a narrow phone, so this version
/// keeps the body centered and lets Wrap flow the badges underneath,
/// falling to as many rows as the screen needs.
class SensorBodyDiagram extends StatelessWidget {
  const SensorBodyDiagram({super.key, required this.sensors});

  final List<SensorReading> sensors;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          const SectionTitleRow(title: 'Sensor Network'),
          const SizedBox(height: 14),
          const _BodySilhouette(),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: sensors.map((s) => _SensorBadge(sensor: s)).toList(),
          ),
        ],
      ),
    );
  }
}

class _BodySilhouette extends StatelessWidget {
  const _BodySilhouette();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [ParaCareColors.cyan.withOpacity(0.35), Colors.transparent],
              ),
            ),
          ),
          Icon(
            Icons.accessibility_new,
            size: 110,
            color: ParaCareColors.deepBlue.withOpacity(0.65),
          ),
        ],
      ),
    );
  }
}

class _SensorBadge extends StatelessWidget {
  const _SensorBadge({required this.sensor});
  final SensorReading sensor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 160),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.55),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ParaCareColors.hairline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(sensor.icon, size: 16, color: ParaCareColors.deepBlue),
            const SizedBox(width: 6),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    sensor.label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: ParaCareColors.ink,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    sensor.placement,
                    style: const TextStyle(fontSize: 9.5, color: ParaCareColors.muted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}