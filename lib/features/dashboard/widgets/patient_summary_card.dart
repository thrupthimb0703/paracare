import 'package:flutter/material.dart';

import '../../../core/dashboard_theme.dart';
import '../../../data/models/patient.dart';

/// The selected-patient card (matches "PC-0011 Karthik S." in the
/// reference). The doctor/last-updated row uses Wrap, not a fixed Row —
/// that's exactly the pattern that caused the PatientQueueCard overflow,
/// so it's avoided here from the start.
class PatientSummaryCard extends StatelessWidget {
  const PatientSummaryCard({super.key, required this.patient, this.onTap});

  final Patient patient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: ParaCareColors.deepBlue.withOpacity(0.12),
                  child: const Icon(Icons.person, color: ParaCareColors.deepBlue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.id,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: ParaCareColors.muted,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        patient.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: ParaCareColors.ink,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      _StatusBadge(status: patient.status),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 18,
              runSpacing: 8,
              children: [
                _metaItem(
                  Icons.person_outline,
                  'Assigned Doctor',
                  patient.assignedDoctor,
                ),
                _metaItem(
                  Icons.access_time,
                  'Last Updated',
                  _formatTime(patient.lastUpdated),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaItem(IconData icon, String label, String value) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: ParaCareColors.muted),
          const SizedBox(width: 6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 10.5, color: ParaCareColors.muted),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: ParaCareColors.ink,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final PatientStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      PatientStatus.critical => ParaCareColors.critical,
      PatientStatus.attention => ParaCareColors.attention,
      PatientStatus.stable => ParaCareColors.stable,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }
}