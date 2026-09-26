enum PatientStatus {
  critical,
  attention,
  stable,
}

extension PatientStatusLabel on PatientStatus {
  String get label {
    switch (this) {
      case PatientStatus.critical:
        return 'CRITICAL';
      case PatientStatus.attention:
        return 'ATTENTION';
      case PatientStatus.stable:
        return 'STABLE';
    }
  }
}

class Patient {
  final String id;
  final String name;
  final String assignedDoctor;
  final PatientStatus status;
  final DateTime lastUpdated;

  const Patient({
    required this.id,
    required this.name,
    required this.assignedDoctor,
    required this.status,
    required this.lastUpdated,
  });
}