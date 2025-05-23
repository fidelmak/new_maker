class Student {
  final String fullName;
  final String firstName;
  final String lastName;
  final String sex;
  final List<AttendanceRecord> attendanceRecords;

  Student({
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.sex,
    List<AttendanceRecord>? attendanceRecords,
  }) : attendanceRecords = attendanceRecords ?? [];

  // Create a copy of the student with optional updates
  Student copyWith({
    String? fullName,
    String? firstName,
    String? lastName,
    String? sex,
    List<AttendanceRecord>? attendanceRecords,
  }) {
    return Student(
      fullName: fullName ?? this.fullName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      sex: sex ?? this.sex,
      attendanceRecords: attendanceRecords ?? this.attendanceRecords,
    );
  }

  // Method to add an attendance record
  void markAttendance(DateTime date) {
    attendanceRecords.add(AttendanceRecord(date: date));
  }
}

class AttendanceRecord {
  final DateTime date;
  final DateTime timestamp;

  AttendanceRecord({required this.date, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'Attendance on ${date.toLocal()} at ${timestamp.toLocal()}';
  }
}
