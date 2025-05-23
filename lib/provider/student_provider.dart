import 'package:attendance_maker/data/data_helper.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/model.dart';

class StudentProvider extends ChangeNotifier {
  List<Student> _students = [];
  List<Student> get students => _students;

  // Current attendance date (defaults to today)
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  // Constructor to initialize the provider
  StudentProvider() {
    loadStudentsFromPrefs();
  }

  // Change the selected date for attendance
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void loadStudentsFromList(List<Map<String, dynamic>> studentData) {
    _students =
        studentData
            .map(
              (data) => Student(
                firstName: data['firstName'] ?? '',
                lastName: data['lastName'] ?? data['middleName'] ?? '',
                sex: data['sex']?.toLowerCase() ?? 'male',
                fullName:
                    '${data['firstName']} ${data['lastName'] ?? data['middleName']}'
                        .trim(),
                attendanceRecords: [],
              ),
            )
            .toList();

    saveStudentsToPrefs();
    notifyListeners();
  }

  // Parse and load students from raw data
  void loadStudents(String rawData) {
    final List<String> lines = rawData.split('\n');
    _students = [];

    for (int i = 0; i < lines.length; i++) {
      final parts = lines[i].trim().split(' ');
      if (parts.length >= 3) {
        // The last part is gender, everything before that is the name
        final String gender = parts.last.toLowerCase();
        if (gender != 'male' && gender != 'female') continue;

        // Get the full name excluding the gender
        final String fullName = parts.sublist(0, parts.length - 1).join(' ');

        // Split name into parts - assuming last name is first, then other names
        final String lastName = parts[0];
        final String firstName =
            parts.length > 2
                ? parts.sublist(1, parts.length - 1).join(' ')
                : parts[1];

        _students.add(
          Student(
            fullName: fullName,
            firstName: firstName,
            lastName: lastName,
            sex: gender,
          ),
        );
      }
    }

    saveStudentsToPrefs();
    notifyListeners();
  }

  // Mark attendance for a specific student
  void markAttendance(Student student, {DateTime? date}) {
    final index = _students.indexWhere((s) => s.fullName == student.fullName);
    if (index != -1) {
      final actualDate = date ?? _selectedDate;

      // Check if attendance for this date already exists
      final existingRecord = _students[index].attendanceRecords.any(
        (record) => isSameDay(record.date, actualDate),
      );

      if (!existingRecord) {
        final updatedRecords = List<AttendanceRecord>.from(
          _students[index].attendanceRecords,
        )..add(AttendanceRecord(date: actualDate));

        _students[index] = _students[index].copyWith(
          attendanceRecords: updatedRecords,
        );

        saveStudentsToPrefs();
        notifyListeners();
      }
    }
  }

  // Remove attendance for a specific student on a specific date
  void removeAttendance(Student student, DateTime date) {
    final index = _students.indexWhere((s) => s.fullName == student.fullName);
    if (index != -1) {
      final updatedRecords =
          _students[index].attendanceRecords
              .where((record) => !isSameDay(record.date, date))
              .toList();

      _students[index] = _students[index].copyWith(
        attendanceRecords: updatedRecords,
      );

      saveStudentsToPrefs();
      notifyListeners();
    }
  }

  // Check if a student is marked present on a specific date
  bool isStudentPresent(Student student, DateTime date) {
    return student.attendanceRecords.any(
      (record) => isSameDay(record.date, date),
    );
  }

  // Get attendance records for a specific student
  List<AttendanceRecord> getStudentAttendance(Student student) {
    final index = _students.indexWhere((s) => s.fullName == student.fullName);
    if (index != -1) {
      return _students[index].attendanceRecords;
    }
    return [];
  }

  // Get all attendance records for a specific date
  List<Map<String, dynamic>> getAttendanceByDate(DateTime date) {
    final records = <Map<String, dynamic>>[];
    for (var student in _students) {
      final record = student.attendanceRecords.firstWhere(
        (r) => isSameDay(r.date, date),
        orElse: () => AttendanceRecord(date: date),
      );

      final isPresent = student.attendanceRecords.any(
        (r) => isSameDay(r.date, date),
      );

      records.add({
        'student': student,
        'isPresent': isPresent,
        'timestamp': isPresent ? record.timestamp : null,
      });
    }
    return records;
  }

  // Get attendance summary for a date range
  Map<String, dynamic> getAttendanceSummary(
    DateTime startDate,
    DateTime endDate,
  ) {
    final Map<String, int> studentAttendance = {};
    final Map<DateTime, int> dateAttendance = {};

    // Initialize student attendance count
    for (var student in _students) {
      studentAttendance[student.fullName] = 0;
    }

    // Count attendance by date and by student
    for (
      var currentDate = startDate;
      currentDate.isBefore(endDate.add(Duration(days: 1)));
      currentDate = currentDate.add(Duration(days: 1))
    ) {
      int presentCount = 0;

      for (var student in _students) {
        final isPresent = student.attendanceRecords.any(
          (record) => isSameDay(record.date, currentDate),
        );

        if (isPresent) {
          studentAttendance[student.fullName] =
              (studentAttendance[student.fullName] ?? 0) + 1;
          presentCount++;
        }
      }

      dateAttendance[currentDate] = presentCount;
    }

    return {
      'byStudent': studentAttendance,
      'byDate': dateAttendance,
      'totalDays': dateAttendance.length,
      'totalStudents': _students.length,
    };
  }

  // Filter students by gender
  List<Student> getStudentsByGender(String gender) {
    return _students
        .where((s) => s.sex.toLowerCase() == gender.toLowerCase())
        .toList();
  }

  // Get total number of students
  int get totalStudents => _students.length;

  // Get number of male and female students
  Map<String, int> get genderCount {
    return {
      'male': _students.where((s) => s.sex.toLowerCase() == 'male').length,
      'female': _students.where((s) => s.sex.toLowerCase() == 'female').length,
    };
  }

  Future<void> saveStudentsToPrefs() async {
    try {
      // First authenticate
      final dbHelper = DatabaseHelper();
      final isAuthenticated = await dbHelper.authenticate('paul', 'paul123');

      if (!isAuthenticated) {
        print('Authentication failed!');
        return;
      }

      // Save each student to SQLite
      for (final student in _students) {
        final studentMap = {
          'fullName': student.fullName,
          'firstName': student.firstName,
          'lastName': student.lastName,
          'sex': student.sex,
        };

        // Insert student and get their ID
        final studentId = await dbHelper.saveStudent(studentMap);

        // Save attendance records
        final records =
            student.attendanceRecords
                .map(
                  (record) => {
                    'date': record.date.toIso8601String(),
                    'timestamp': record.timestamp.toIso8601String(),
                  },
                )
                .toList();

        await dbHelper.saveAttendanceRecords(studentId, records);
      }

      print('Students saved to SQLite successfully!');
    } catch (e) {
      print('Error saving students to database: $e');
    }
  }
  // // Save students data to SharedPreferences
  // Future<void> saveStudentsToPrefs() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final List<Map<String, dynamic>> studentsData = [];

  //     for (var student in _students) {
  //       final Map<String, dynamic> studentMap = {
  //         'fullName': student.fullName,
  //         'firstName': student.firstName,
  //         'lastName': student.lastName,
  //         'sex': student.sex,
  //         'attendanceRecords':
  //             student.attendanceRecords
  //                 .map(
  //                   (record) => {
  //                     'date': record.date.toIso8601String(),
  //                     'timestamp': record.timestamp.toIso8601String(),
  //                   },
  //                 )
  //                 .toList(),
  //       };
  //       studentsData.add(studentMap);
  //     }

  //     final String encodedData = jsonEncode(studentsData);
  //     await prefs.setString('students_data', encodedData);
  //   } catch (e) {
  //     print('Error saving students data: $e');
  //   }
  // }

  // Load students data from SharedPreferences
  Future<void> loadStudentsFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? studentsJson = prefs.getString('students_data');

      if (studentsJson != null) {
        final List<dynamic> studentsData = jsonDecode(studentsJson);
        _students =
            studentsData.map((data) {
              final List<AttendanceRecord> records =
                  (data['attendanceRecords'] as List)
                      .map(
                        (record) => AttendanceRecord(
                          date: DateTime.parse(record['date']),
                          timestamp: DateTime.parse(record['timestamp']),
                        ),
                      )
                      .toList();

              return Student(
                fullName: data['fullName'],
                firstName: data['firstName'],
                lastName: data['lastName'],
                sex: data['sex'],
                attendanceRecords: records,
              );
            }).toList();

        notifyListeners();
      }
    } catch (e) {
      print('Error loading students data: $e');
    }
  }

  // Helper function to compare dates (ignoring time)
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
