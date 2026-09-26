import 'package:flutter/material.dart';

/// "Patient Queue" summary card shown on the dashboard home tab.
///
/// This widget is presentation-only and takes plain counts — no Firestore
/// or patient model dependency yet. Mock numbers are passed in from
/// [DashboardScreen] for now; a later step will swap that call site for a
/// live Firestore-backed count without changing this widget's API.
class PatientQueueCard extends StatelessWidget {
  const PatientQueueCard({
    super.key,
    required this.activeCount,
    required this.totalCount,
    required this.criticalCount,
    required this.attentionCount,
    required this.stableCount,
    this.onTap,
  });

  final int activeCount;
  final int totalCount;
  final int criticalCount;
  final int attentionCount;
  final int stableCount;
  final VoidCallback? onTap;

  static const _deepBlue = Color(0xFF1D4ED8);
  static const _critical = Color(0xFFEF4444);
  static const _attention = Color(0xFFF59E0B);
  static const _stable = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.62),
              border: Border.all(
                color: const Color(0xFFDCEAFE).withOpacity(0.9),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF22D3EE).withOpacity(0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                _iconBadge(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Patient Queue',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Color(0xFF0F172A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: _stable,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$activeCount / $totalCount Patients',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),

                      // Wrap prevents the 21-pixel overflow on narrow phones.
                      Wrap(
                        spacing: 14,
                        runSpacing: 6,
                        children: [
                          _countChip(
                            _critical,
                            criticalCount,
                            'Critical',
                          ),
                          _countChip(
                            _attention,
                            attentionCount,
                            'Attention',
                          ),
                          _countChip(
                            _stable,
                            stableCount,
                            'Stable',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconBadge() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _deepBlue.withOpacity(0.10),
      ),
      child: const Icon(
        Icons.groups_outlined,
        color: _deepBlue,
        size: 22,
      ),
    );
  }

  Widget _countChip(Color color, int count, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF0F172A),
            ),
            children: [
              TextSpan(
                text: '$count ',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: label,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}