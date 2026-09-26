import 'package:flutter/material.dart';

/// Shared visual language for the dashboard's new widgets, matching the
/// blue/cyan glassmorphism already used in dashboard_header.dart and
/// patient_queue_card.dart. Those two files are NOT changed to use this —
/// they keep their own inline styles untouched, per the "don't touch
/// working files unnecessarily" rule. Only the new widgets below use it.
class ParaCareColors {
  ParaCareColors._();

  static const deepBlue = Color(0xFF1D4ED8);
  static const cyan = Color(0xFF22D3EE);
  static const critical = Color(0xFFEF4444);
  static const attention = Color(0xFFF59E0B);
  static const stable = Color(0xFF22C55E);
  static const ink = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const hairline = Color(0xFFDCEAFE);
}

/// The frosted rounded-card container used by every new dashboard section.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.62),
        border: Border.all(color: ParaCareColors.hairline.withOpacity(0.9)),
        boxShadow: [
          BoxShadow(
            color: ParaCareColors.cyan.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class LiveDot extends StatelessWidget {
  const LiveDot({super.key, this.color = ParaCareColors.stable});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

/// A card's title row: title on the left (ellipsis-safe via Expanded),
/// optional "Live"-style dot + label on the right. Used instead of a plain
/// Row so every section header is overflow-safe by construction.
class SectionTitleRow extends StatelessWidget {
  const SectionTitleRow({
    super.key,
    required this.title,
    this.trailingLabel,
    this.dotColor = ParaCareColors.stable,
  });

  final String title;
  final String? trailingLabel;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: ParaCareColors.ink,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailingLabel != null) ...[
          const SizedBox(width: 8),
          LiveDot(color: dotColor),
          const SizedBox(width: 6),
          Text(
            trailingLabel!,
            style: TextStyle(
              fontSize: 12,
              color: dotColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}