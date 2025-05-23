import 'package:attendance_maker/model/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "dart:async";

import 'package:intl/intl.dart';

import '../provider/student_provider.dart';

class AttendanceMarkingScreen extends StatefulWidget {
  const AttendanceMarkingScreen({Key? key}) : super(key: key);

  @override
  _AttendanceMarkingScreenState createState() =>
      _AttendanceMarkingScreenState();
}

class _AttendanceMarkingScreenState extends State<AttendanceMarkingScreen> {
  String _searchQuery = '';
  List<String> _markedStudents = [];
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set the selected date in the provider
      Provider.of<StudentProvider>(
        context,
        listen: false,
      ).setSelectedDate(_selectedDate);

      // Initialize marked students list from existing attendance data
      _initializeMarkedStudents();
    });
  }

  void _initializeMarkedStudents() {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    final students = provider.students;

    _markedStudents =
        students
            .where(
              (student) => provider.isStudentPresent(student, _selectedDate),
            )
            .map((student) => student.fullName)
            .toList();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;

        // Update the provider with the new date
        Provider.of<StudentProvider>(
          context,
          listen: false,
        ).setSelectedDate(_selectedDate);

        // Reset marked students based on the new date
        _initializeMarkedStudents();
      });
    }
  }

  void _toggleAttendance(Student student) {
    final provider = Provider.of<StudentProvider>(context, listen: false);

    setState(() {
      if (_markedStudents.contains(student.fullName)) {
        _markedStudents.remove(student.fullName);
        provider.removeAttendance(student, _selectedDate);
      } else {
        _markedStudents.add(student.fullName);
        provider.markAttendance(student, date: _selectedDate);
      }
    });
  }

  void _markAllPresent() {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    final students = provider.students;

    setState(() {
      for (var student in students) {
        if (!_markedStudents.contains(student.fullName)) {
          _markedStudents.add(student.fullName);
          provider.markAttendance(student, date: _selectedDate);
        }
      }
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('All students marked present')));
  }

  void _markAllAbsent() {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    final students = provider.students;

    setState(() {
      for (var student in students) {
        if (_markedStudents.contains(student.fullName)) {
          _markedStudents.remove(student.fullName);
          provider.removeAttendance(student, _selectedDate);
        }
      }
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('All students marked absent')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark Attendance'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date display
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: ${DateFormat('dd-MM-yyyy').format(_selectedDate)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Consumer<StudentProvider>(
                  builder: (context, provider, child) {
                    return Text(
                      'Present: ${_markedStudents.length}/${provider.students.length}',
                      style: TextStyle(fontSize: 16),
                    );
                  },
                ),
              ],
            ),
          ),

          // Search field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Students',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Mark all buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.check_circle),
                    label: Text('Mark All Present'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _markAllPresent,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.cancel),
                    label: Text('Mark All Absent'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _markAllAbsent,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          // Students list
          Expanded(
            child: Consumer<StudentProvider>(
              builder: (context, provider, child) {
                final students = provider.students;
                final filteredStudents =
                    students
                        .where(
                          (student) => student.fullName.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          ),
                        )
                        .toList();

                if (filteredStudents.isEmpty) {
                  return Center(child: Text('No students found'));
                }

                return ListView.builder(
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];
                    final isPresent = _markedStudents.contains(
                      student.fullName,
                    );

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      color: isPresent ? Colors.green.shade50 : Colors.white,
                      child: CheckboxListTile(
                        title: Text(student.fullName),
                        subtitle: Text(
                          student.sex == 'male' ? 'Male' : 'Female',
                        ),
                        secondary: CircleAvatar(
                          child: Text(student.firstName[0]),
                          backgroundColor:
                              student.sex == 'male'
                                  ? Colors.blue.shade200
                                  : Colors.pink.shade200,
                        ),
                        value: isPresent,
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                        onChanged: (bool? value) {
                          _toggleAttendance(student);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Go back to previous screen after saving
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Attendance saved successfully')),
          );
        },
        label: Text('Save Attendance'),
        icon: Icon(Icons.save),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
