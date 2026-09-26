import 'package:flutter/material.dart';

import '../../../core/dashboard_theme.dart';

/// Animated ECG trace drawn with CustomPainter inside a fixed-height,
/// full-width box (height: 90). No package added — pure Flutter drawing.
class LiveEcgCard extends StatefulWidget {
  const LiveEcgCard({super.key, this.onViewFull});

  final VoidCallback? onViewFull;

  @override
  State<LiveEcgCard> createState() => _LiveEcgCardState();
}

class _LiveEcgCardState extends State<LiveEcgCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // One PQRST-like cycle, normalized -1..1, repeated to fill the trace.
  static const List<double> _pattern = [
    0, 0, 0.05, 0, -0.05, 0, 0.15, 0.9, -0.3, 0.05, 0, 0, 0.25, 0.4, 0.2, 0, 0,
    0, 0, 0, 0, 0, 0.05, 0, -0.05, 0, 0.15, 0.9, -0.3, 0.05, 0, 0, 0.25, 0.4,
    0.2, 0, 0, 0, 0, 0,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitleRow(
            title: 'Live ECG',
            trailingLabel: 'Live',
            dotColor: ParaCareColors.stable,
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 90,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1E3D),
              borderRadius: BorderRadius.circular(14),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _EcgPainter(
                    progress: _controller.value,
                    pattern: _pattern,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onViewFull,
              child: const Text(
                'View Live ECG  →',
                style: TextStyle(
                  color: ParaCareColors.deepBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EcgPainter extends CustomPainter {
  _EcgPainter({required this.progress, required this.pattern});

  final double progress;
  final List<double> pattern;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF22D3EE)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    const pointCount = 100;
    final shift = (progress * pattern.length).floor();

    for (int i = 0; i < pointCount; i++) {
      final sampleIndex = (i + shift) % pattern.length;
      final x = size.width * i / (pointCount - 1);
      final normalized = pattern[sampleIndex];
      final y = size.height / 2 - normalized * (size.height / 2 - 10);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _EcgPainter oldDelegate) =>
      oldDelegate.progress != progress;
}