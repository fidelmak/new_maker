import 'package:attendance_maker/screens/admin_panel.dart';
import 'package:attendance_maker/widget/bulkdialogue.dart';
import 'package:attendance_maker/widget/mydialogue.dart';
import 'package:flutter/material.dart';

import '../provider/student_provider.dart';
import 'package:provider/provider.dart';
import '../model/model.dart';
import '../utility/utils.dart';
import 'attendance_mark.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({Key? key}) : super(key: key);

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Check if students data is empty on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<StudentProvider>(context, listen: false);
      if (provider.students.isEmpty) {
        _showStudentInputOptions();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Show dialog with options to add students
  void _showStudentInputOptions() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Add Students'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.person_add),
                  label: Text('Add Single Student'),
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AddStudentDialog(),
                    );
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.upload_file),
                  label: Text('Bulk Import Students'),
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => BulkStudentImportDialog(),
                    );
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
    );
  }

  // Filter students based on search query
  List<Student> _filterStudents(List<Student> students) {
    if (_searchQuery.isEmpty) return students;

    return students
        .where(
          (student) => student.fullName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Attendance Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminPanelScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showStudentInputOptions,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(text: 'All'), Tab(text: 'Male'), Tab(text: 'Female')],
        ),
      ),
      body: Column(
        children: [
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
          Consumer<StudentProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: ${provider.totalStudents} students'),
                    Text(
                      '♂️ ${provider.genderCount['male'] ?? 0} | ♀️ ${provider.genderCount['female'] ?? 0}',
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All Students Tab
                Consumer<StudentProvider>(
                  builder: (context, provider, child) {
                    final filteredStudents = _filterStudents(provider.students);
                    return _buildStudentList(filteredStudents);
                  },
                ),
                // Male Students Tab
                Consumer<StudentProvider>(
                  builder: (context, provider, child) {
                    final filteredStudents = _filterStudents(
                      provider.getStudentsByGender('male'),
                    );
                    return _buildStudentList(filteredStudents);
                  },
                ),
                // Female Students Tab
                Consumer<StudentProvider>(
                  builder: (context, provider, child) {
                    final filteredStudents = _filterStudents(
                      provider.getStudentsByGender('female'),
                    );
                    return _buildStudentList(filteredStudents);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Check if there are students before navigating
          final provider = Provider.of<StudentProvider>(context, listen: false);
          if (provider.students.isEmpty) {
            // Show dialog to add students first
            _showStudentInputOptions();
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AttendanceMarkingScreen(),
              ),
            );
          }
        },
        label: Text('Mark Attendance'),
        icon: Icon(Icons.check),
      ),
    );
  }

  Widget _buildStudentList(List<Student> students) {
    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No students found'),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.person_add),
              label: Text('Add Students'),
              onPressed: _showStudentInputOptions,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(student.firstName[0]),
              backgroundColor:
                  student.sex.toLowerCase() == 'male'
                      ? Colors.blue.shade200
                      : Colors.pink.shade200,
            ),
            title: Text(student.fullName),
            subtitle: Text(
              'Last attendance: ${student.attendanceRecords.isNotEmpty ? '${student.attendanceRecords.last.date.day}/${student.attendanceRecords.last.date.month}/${student.attendanceRecords.last.date.year}' : 'Never'}',
            ),
            trailing: Text(
              student.sex == 'male' ? '♂️' : '♀️',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              // Show student details
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => _buildStudentDetails(student),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStudentDetails(Student student) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      student.sex.toLowerCase() == 'male'
                          ? Colors.blue.shade50
                          : Colors.pink.shade50,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor:
                          student.sex.toLowerCase() == 'male'
                              ? Colors.blue.shade200
                              : Colors.pink.shade200,
                      child: Text(
                        student.firstName[0].toUpperCase(),
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.fullName,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                student.sex.toLowerCase() == 'male'
                                    ? Icons.male
                                    : Icons.female,
                                color:
                                    student.sex.toLowerCase() == 'male'
                                        ? Colors.blue
                                        : Colors.pink,
                              ),
                              SizedBox(width: 8),
                              Text(
                                student.sex.toLowerCase() == 'male'
                                    ? 'Male'
                                    : 'Female',
                                style: TextStyle(
                                  color:
                                      student.sex.toLowerCase() == 'male'
                                          ? Colors.blue
                                          : Colors.pink,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Attendance Summary
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      'Total Attendance',
                      '${student.attendanceRecords.length}',
                      Icons.calendar_today,
                      Colors.green,
                    ),
                    _buildStatCard(
                      'First Attendance',
                      student.attendanceRecords.isNotEmpty
                          ? DateFormat(
                            'dd-MM-yyyy',
                          ).format(student.attendanceRecords.first.date)
                          : 'Never',
                      Icons.event_available,
                      Colors.blue,
                    ),
                  ],
                ),
              ),

              // Attendance History Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Attendance History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              // Attendance Records
              Expanded(
                child:
                    student.attendanceRecords.isEmpty
                        ? Center(
                          child: Text(
                            'No attendance records',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                        : ListView.builder(
                          controller: controller,
                          itemCount: student.attendanceRecords.length,
                          itemBuilder: (context, index) {
                            final record = student.attendanceRecords[index];
                            return ListTile(
                              leading: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              title: Text(
                                DateFormat('dd-MM-yyyy').format(record.date),
                              ),
                              subtitle: Text(
                                'Marked at: ${DateFormat('HH:mm').format(record.timestamp)}',
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to build stat cards
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
