import 'package:attendance_maker/provider/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddStudentDialog extends StatefulWidget {
  const AddStudentDialog({Key? key}) : super(key: key);

  @override
  _AddStudentDialogState createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  String _selectedGender = 'male'; // Default gender

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    super.dispose();
  }

  void _submitStudent() {
    if (_formKey.currentState!.validate()) {
      // Construct the student data string
      final studentData =
          '${_lastNameController.text} ${_firstNameController.text} $_selectedGender';

      // Load the student via provider
      Provider.of<StudentProvider>(
        context,
        listen: false,
      ).loadStudents(studentData);

      // Clear text fields
      _lastNameController.clear();
      _firstNameController.clear();

      // Close the dialog
      Navigator.of(context).pop();

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Student added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Student'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Last Name Input
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              SizedBox(height: 16),

              // First Name Input
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              SizedBox(height: 16),

              // Gender Selection
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people),
                ),
                value: _selectedGender,
                items: [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        // Add Student Button
        ElevatedButton(
          onPressed: _submitStudent,
          child: Text('Add Student'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
