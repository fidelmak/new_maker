import '../model/model.dart';

class StudentParser {
  static List<Student> parseStudentData(String rawData) {
    // Remove multiple spaces and replace dots with spaces
    final cleanedData =
        rawData.replaceAll(RegExp(r'\s+'), ' ').replaceAll('.', '').trim();

    final students = <Student>[];
    final parts = cleanedData.split(' ');

    for (int i = 0; i < parts.length; i += 3) {
      if (i + 2 >= parts.length) break;

      final lastName = parts[i];
      final firstName = parts[i + 1];
      final sex = parts[i + 2].toLowerCase();

      // Validate sex
      if (sex != 'male' && sex != 'female') continue;

      students.add(
        Student(
          fullName: '$firstName $lastName',
          firstName: firstName,
          lastName: lastName,
          sex: sex,
        ),
      );
    }

    return students;
  }

  // Method to filter students by gender
  static List<Student> filterByGender(List<Student> students, String gender) {
    return students
        .where((student) => student.sex.toLowerCase() == gender.toLowerCase())
        .toList();
  }
}
