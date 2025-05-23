import 'package:attendance_maker/model/model.dart';
import 'package:attendance_maker/provider/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BulkStudentImportDialog extends StatefulWidget {
  @override
  _BulkStudentImportDialogState createState() =>
      _BulkStudentImportDialogState();
}

class _BulkStudentImportDialogState extends State<BulkStudentImportDialog> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _parsedStudents = [];
  String _errorMessage = '';
  bool _isParsing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _parseStudents() {
    setState(() {
      _isParsing = true;
      _errorMessage = '';
      _parsedStudents = [];
    });

    try {
      final String text = _controller.text.trim();
      if (text.isEmpty) {
        setState(() {
          _errorMessage = 'Please enter student data';
          _isParsing = false;
        });
        return;
      }

      // Split by newlines to support both single line and multi-line input
      final lines = text.split(RegExp(r'\r?\n'));

      for (final line in lines) {
        if (line.trim().isEmpty) continue;

        // Attempt to parse the line in format: "LASTNAME FIRSTNAME MIDDLENAME gender"
        final parts = line.trim().split(RegExp(r'\s+'));

        if (parts.length < 3) {
          throw Exception(
            'Invalid format in line: $line. Expected at least 3 parts.',
          );
        }

        // Extract gender which should be the last part
        final String gender = parts.last.toLowerCase();
        if (gender != 'male' && gender != 'female') {
          throw Exception(
            'Invalid gender in line: $line. Expected "male" or "female".',
          );
        }

        // The name parts are everything except the last part (gender)
        final nameParts = parts.sublist(0, parts.length - 1);

        // The first part is the last name
        final String lastName = nameParts[0];

        // The rest are the first name and middle name (if any)
        String firstName = '';
        String middleName = '';

        if (nameParts.length >= 2) {
          firstName = nameParts[1];

          if (nameParts.length >= 3) {
            // Join all remaining parts as middle name
            middleName = nameParts.sublist(2).join(' ');
          }
        }

        _parsedStudents.add({
          'firstName': firstName,
          'lastName': lastName,
          'middleName': middleName,
          'sex': gender,
        });
      }

      if (_parsedStudents.isEmpty) {
        setState(() {
          _errorMessage = 'No valid student data found';
          _isParsing = false;
        });
        return;
      }

      setState(() {
        _isParsing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isParsing = false;
      });
    }
  }

  void _saveStudents() {
    if (_parsedStudents.isEmpty) {
      setState(() {
        _errorMessage = 'No students to save';
      });
      return;
    }

    final provider = Provider.of<StudentProvider>(context, listen: false);

    for (final data in _parsedStudents) {
      //
      // Convert each parsed student data into a Student object
      final List<Student> student =
          _parsedStudents.map((data) {
            return Student(
              firstName: data['firstName'] ?? '',
              lastName: data['lastName'] ?? data['middleName'] ?? '',
              sex: data['sex']?.toLowerCase() ?? 'male',
              fullName:
                  '${data['firstName']} ${data['lastName'] ?? data['middleName']}'
                      .trim(),
              attendanceRecords: [],
            );
          }).toList();
      final List<Map<String, dynamic>> studentMaps =
          student.map((student) {
            return {
              'firstName': student.firstName,
              'lastName': student.lastName,
              'sex': student.sex,
              'fullName': student.fullName,
              'attendanceRecords': [], // or convert records if needed
            };
          }).toList();

      provider.loadStudentsFromList(studentMaps.cast<Map<String, dynamic>>());
    }

    // Show success snackbar after dismissing dialog
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_parsedStudents.length} students imported successfully',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Bulk Import Students'),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paste student data in the format:\nLASTNAME FIRSTNAME MIDDLENAME gender\n\nExample:\nABAYOMI Praise Olajuwon female\nADEWOLE John Peter male',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 8,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Paste student data here...',
              ),
            ),
            SizedBox(height: 8),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
              ),
            if (_parsedStudents.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Successfully parsed ${_parsedStudents.length} students',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            if (_parsedStudents.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      _parsedStudents.length > 5 ? 5 : _parsedStudents.length,
                  itemBuilder: (context, index) {
                    final student = _parsedStudents[index];
                    return ListTile(
                      dense: true,
                      title: Text(
                        '${student['lastName']} ${student['firstName']} ${student['middleName']}',
                        style: TextStyle(fontSize: 13),
                      ),
                      subtitle: Text(
                        '${student['sex']}',
                        style: TextStyle(fontSize: 12),
                      ),
                      leading: Icon(
                        student['sex'] == 'male' ? Icons.male : Icons.female,
                        color:
                            student['sex'] == 'male'
                                ? Colors.blue
                                : Colors.pink,
                        size: 18,
                      ),
                    );
                  },
                ),
              ),
            if (_parsedStudents.length > 5)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '... and ${_parsedStudents.length - 5} more',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isParsing ? null : _parseStudents,
          child:
              _isParsing
                  ? SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : Text('Parse'),
        ),
        ElevatedButton(
          onPressed: _parsedStudents.isEmpty ? null : _saveStudents,
          child: Text('Import Students'),
        ),
      ],
    );
  }
}
