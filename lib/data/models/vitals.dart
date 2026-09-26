import 'package:flutter/material.dart' show IconData;

/// Snapshot of a patient's live vital signs. In production this comes from
/// the chest hub over Firebase; for now it's plain mock data.
class Vitals {
  final double spo2Percent;
  final int heartRateBpm;
  final int respirationRpm;
  final double temperatureCelsius;

  const Vitals({
    required this.spo2Percent,
    required this.heartRateBpm,
    required this.respirationRpm,
    required this.temperatureCelsius,
  });
}

/// One physical sensor/strap feeding the dashboard's body diagram.
class SensorReading {
  final String code;
  final String label;
  final String placement;
  final IconData icon;

  const SensorReading({
    required this.code,
    required this.label,
    required this.placement,
    required this.icon,
  });
}