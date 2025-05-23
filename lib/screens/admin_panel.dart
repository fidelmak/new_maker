import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../provider/student_provider.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime _endDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_startDate.isAfter(_endDate)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  Future<void> _selectSingleDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Daily Report'),
            Tab(text: 'Date Range'),
            Tab(text: 'Statistics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Daily Report Tab
          _buildDailyReportTab(),

          // Date Range Tab
          _buildDateRangeTab(),

          // Statistics Tab
          _buildStatisticsTab(),
        ],
      ),
    );
  }

  Widget _buildDailyReportTab() {
    return Column(
      children: [
        // Date Selection
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date: ${DateFormat('dd-MM-yyyy').format(_selectedDate)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.calendar_today),
                label: Text('Select Date'),
                onPressed: () => _selectSingleDate(context),
              ),
            ],
          ),
        ),

        // Daily Attendance Report
        Expanded(
          child: Consumer<StudentProvider>(
            builder: (context, provider, child) {
              final attendanceRecords = provider.getAttendanceByDate(
                _selectedDate,
              );

              return ListView.builder(
                itemCount: attendanceRecords.length,
                itemBuilder: (context, index) {
                  final record = attendanceRecords[index];
                  final student = record['student'];

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(student.firstName[0]),
                      backgroundColor:
                          student.sex == 'male'
                              ? Colors.blue.shade200
                              : Colors.pink.shade200,
                    ),
                    title: Text(student.fullName),
                    trailing:
                        record['isPresent']
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : Icon(Icons.cancel, color: Colors.red),
                    subtitle:
                        record['isPresent']
                            ? Text(
                              'Marked at: ${DateFormat('HH:mm').format(record['timestamp'])}',
                            )
                            : null,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeTab() {
    return Column(
      children: [
        // Date Range Selection
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start Date: ${DateFormat('dd-MM-yyyy').format(_startDate)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    child: Text('Select Start Date'),
                    onPressed: () => _selectDate(context, true),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'End Date: ${DateFormat('dd-MM-yyyy').format(_endDate)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    child: Text('Select End Date'),
                    onPressed: () => _selectDate(context, false),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Attendance Summary
        Expanded(
          child: Consumer<StudentProvider>(
            builder: (context, provider, child) {
              final summary = provider.getAttendanceSummary(
                _startDate,
                _endDate,
              );

              return ListView(
                children: [
                  // Summary Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Total Days Card
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  'Total Days',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${summary['totalDays']}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Student Attendance Summary
                        Card(
                          child: ExpansionTile(
                            title: Text(
                              'Student Attendance Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children:
                                summary['byStudent'].entries.map<Widget>((
                                  entry,
                                ) {
                                  return ListTile(
                                    title: Text(entry.key),
                                    trailing: Text(
                                      '${entry.value} / ${summary['totalDays']} days',
                                      style: TextStyle(
                                        color: _getAttendanceColor(
                                          entry.value,
                                          summary['totalDays'],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),

                        // Date-wise Attendance Card
                        Card(
                          child: ExpansionTile(
                            title: Text(
                              'Daily Attendance',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children:
                                summary['byDate'].entries.map<Widget>((entry) {
                                  return ListTile(
                                    title: Text(
                                      DateFormat(
                                        'dd-MM-yyyy',
                                      ).format(entry.key),
                                    ),
                                    trailing: Text(
                                      '${entry.value} / ${summary['totalStudents']} present',
                                      style: TextStyle(
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsTab() {
    return Consumer<StudentProvider>(
      builder: (context, provider, child) {
        final genderCount = provider.genderCount;

        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Total Students Card
            Card(
              child: ListTile(
                title: Text(
                  'Total Students',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  '${provider.totalStudents}',
                  style: TextStyle(fontSize: 24, color: Colors.blue),
                ),
              ),
            ),

            // Gender Distribution Card
            Card(
              child: ListTile(
                title: Text(
                  'Gender Distribution',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  '♂️ ${genderCount['male'] ?? 0} | ♀️ ${genderCount['female'] ?? 0}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),

            // Detailed Gender Breakdown
            Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Gender Breakdown',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.male, color: Colors.blue),
                    title: Text('Male Students'),
                    trailing: Text(
                      '${genderCount['male'] ?? 0}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.female, color: Colors.pink),
                    title: Text('Female Students'),
                    trailing: Text(
                      '${genderCount['female'] ?? 0}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Percentage Distribution',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildPercentageBar(
                    maleCount: genderCount['male'] ?? 0,
                    femaleCount: genderCount['female'] ?? 0,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper method to get attendance color based on percentage
  Color _getAttendanceColor(int attendedDays, int totalDays) {
    final percentage = (attendedDays / totalDays * 100).round();
    if (percentage >= 90) return Colors.green.shade700;
    if (percentage >= 75) return Colors.orange.shade700;
    return Colors.red.shade700;
  }

  // Percentage distribution bar
  Widget _buildPercentageBar({
    required int maleCount,
    required int femaleCount,
  }) {
    final total = maleCount + femaleCount;
    final malePercentage = total > 0 ? (maleCount / total * 100) : 0;
    final femalePercentage = total > 0 ? (femaleCount / total * 100) : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            Expanded(
              flex: maleCount,
              child: Container(
                height: 20,
                color: Colors.blue.shade400,
                child: Center(
                  child: Text(
                    '♂️ ${malePercentage.toStringAsFixed(1)}%',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: femaleCount,
              child: Container(
                height: 20,
                color: Colors.pink.shade400,
                child: Center(
                  child: Text(
                    '♀️ ${femalePercentage.toStringAsFixed(1)}%',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
