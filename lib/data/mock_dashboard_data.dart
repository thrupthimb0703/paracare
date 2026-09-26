import 'package:flutter/material.dart';

import 'models/patient.dart';
import 'models/vitals.dart';

/// Hardcoded dashboard data while Firestore-backed patient/vitals
/// collections aren't wired up yet. The widgets that consume this only
/// depend on the Patient / Vitals / SensorReading types — swap the call
/// sites in DashboardScreen for real Firestore streams later without
/// touching the widgets themselves.
class MockDashboardData {
  MockDashboardData._();

  static final Patient selectedPatient = Patient(
    id: 'PC-0011',
    name: 'Karthik S.',
    assignedDoctor: 'Dr. Aisha Verma',
    status: PatientStatus.critical,
    lastUpdated: DateTime.now(),
  );

  static const Vitals vitals = Vitals(
    spo2Percent: 98,
    heartRateBpm: 72,
    respirationRpm: 16,
    temperatureCelsius: 36.7,
  );

  static const List<SensorReading> sensors = [
    SensorReading(
      code: 'ADS1292R',
      label: 'ECG + Respiration',
      placement: 'Chest Strap',
      icon: Icons.monitor_heart_outlined,
    ),
    SensorReading(
      code: 'MLX90632',
      label: 'Temperature',
      placement: 'Chest Strap',
      icon: Icons.thermostat_outlined,
    ),
    SensorReading(
      code: 'MAX86141',
      label: 'SpO₂ + Pulse/HR',
      placement: 'Left Hand Strap',
      icon: Icons.water_drop_outlined,
    ),
    SensorReading(
      code: 'MAX86141',
      label: 'SpO₂ + Pulse/HR',
      placement: 'Right Hand Strap',
      icon: Icons.water_drop_outlined,
    ),
    SensorReading(
      code: 'BMI270',
      label: 'Limb Movement',
      placement: 'Left Leg Strap',
      icon: Icons.directions_walk_outlined,
    ),
    SensorReading(
      code: 'BMI270',
      label: 'Limb Movement',
      placement: 'Right Leg Strap',
      icon: Icons.directions_walk_outlined,
    ),
  ];
}