import 'package:flutter/material.dart';

import '../../../core/dashboard_theme.dart';

class DetailedInfoButton extends StatelessWidget {
  const DetailedInfoButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [ParaCareColors.deepBlue, ParaCareColors.cyan],
          ),
          boxShadow: [
            BoxShadow(
              color: ParaCareColors.cyan.withOpacity(0.30),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.description_outlined, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Detailed Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Vitals · ECG · Trends · Events · Sensors',
                    style: TextStyle(color: Colors.white70, fontSize: 10.5),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}