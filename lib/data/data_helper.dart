import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'student_attendance.db');

    return await openDatabase(dbPath, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table (for authentication)
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Create students table
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT NOT NULL,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        sex TEXT NOT NULL
      )
    ''');

    // Create attendance_records table
    await db.execute('''
      CREATE TABLE attendance_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentId INTEGER NOT NULL,
        date TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (studentId) REFERENCES students (id)
      )
    ''');

    // Insert default user (paul:paul123)
    final hashedPassword = _hashPassword('paul123');
    await db.insert('users', {'username': 'paul', 'password': hashedPassword});
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<bool> authenticate(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isEmpty) return false;

    final storedPassword = result.first['password'] as String;
    return storedPassword == _hashPassword(password);
  }

  Future<int> saveStudent(Map<String, dynamic> student) async {
    final db = await database;
    return await db.insert('students', {
      'fullName': student['fullName'],
      'firstName': student['firstName'],
      'lastName': student['lastName'],
      'sex': student['sex'],
    });
  }

  Future<void> saveAttendanceRecords(
    int studentId,
    List<Map<String, dynamic>> records,
  ) async {
    final db = await database;
    final batch = db.batch();

    for (final record in records) {
      batch.insert('attendance_records', {
        'studentId': studentId,
        'date': record['date'],
        'timestamp': record['timestamp'],
      });
    }

    await batch.commit();
  }
}
