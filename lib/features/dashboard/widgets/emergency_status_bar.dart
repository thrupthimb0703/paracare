import 'package:flutter/material.dart';

import '../../../core/dashboard_theme.dart';

class EmergencyStatusBar extends StatelessWidget {
  const EmergencyStatusBar({super.key, this.statusLabel = 'Ready', this.onTap});

  final String statusLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ParaCareColors.stable.withOpacity(0.12),
              ),
              child: const Icon(Icons.shield_outlined, color: ParaCareColors.stable, size: 18),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Emergency System',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: ParaCareColors.ink,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: ParaCareColors.stable.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LiveDot(),
                  const SizedBox(width: 5),
                  Text(
                    statusLabel,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: ParaCareColors.stable,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}