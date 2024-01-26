import 'package:attendence_sys/Student/MarkAt.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

late Database _database;

class DatabaseHelper {
  Future<void> initializeDatabase() async {
    String path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, 'attendence_database.db'),
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE attendence_records( 
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              firstName TEXT,
              lastName TEXT,
              registrationNumber TEXT,
              className TEXT,
              date TEXT,
              isPresent INTEGER )''');

        await db.execute('''CREATE TABLE leave_requests( 
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_email TEXT,
              reason TEXT )''');
      },
      version: 1,
    );
  }

  Future<void> insertAttendanceRecord(AttendanceRecord record) async {
    await _database.insert('attendence_records', record.toMap());
  }

  Future<void> deleteAttendanceRecord(DateTime date) async {
    await _database.delete(
      'attendence_records',
      where: 'date = ?',
      whereArgs: [date.toIso8601String()],
    );
  }

  Future<List<AttendanceRecord>> getAllAttendanceRecordsForUser(
      String userName) async {
    final List<Map<String, dynamic>> records = await _database.query(
      'attendence_records',
      where: 'firstName || lastName = ?',
      whereArgs: [userName],
      orderBy: 'date DESC',
    );

    return records.map((record) {
      return AttendanceRecord(
        firstName: record['firstName'],
        lastName: record['lastName'],
        regNum: record['registrationNumber'],
        className: record['className'],
        date: DateTime.parse(record['date']),
        isPresent: record['isPresent'] == 1,
      );
    }).toList();
  }

  Future<List<AttendanceRecord>> getAllAttendanceRecords() async {
    final List<Map<String, dynamic>> records = await _database.query(
      'attendence_records',
      orderBy: 'date DESC',
    );

    return records.map((record) {
      return AttendanceRecord(
        firstName: record['firstName'],
        lastName: record['lastName'],
        regNum: record['registrationNumber'],
        className: record['className'],
        date: DateTime.parse(record['date']),
        isPresent: record['isPresent'] == 1,
      );
    }).toList();
  }

  Future<void> updateAttendanceRecord(AttendanceRecord record) async {
    await _database.update(
      'attendence_records',
      {
        'firstName': record.firstName,
        'lastName': record.lastName,
        'registrationNumber': record.regNum,
        'className': record.className,
        'date': record.date.toIso8601String(),
        'isPresent': record.isPresent ? 1 : 0,
      },
      where: 'firstName = ? AND lastName = ? ',
      whereArgs: [
        record.firstName,
        record.lastName,
      ],
    );
  }

  Future<AttendanceRecord?> getAttendanceRecordByNameAndDate(
      String firstName, String lastName, DateTime date) async {
    final List<Map<String, dynamic>> records = await _database.query(
      'attendence_records',
      where: 'LOWER(firstName) = ? AND LOWER(lastName) = ? AND date = ?',
      whereArgs: [
        firstName.toLowerCase(),
        lastName.toLowerCase(),
        DateFormat('yyyy-MM-dd').format(date),
      ],
      limit: 1,
    );

    if (records.isNotEmpty) {
      return AttendanceRecord(
        firstName: records[0]['firstName'],
        lastName: records[0]['lastName'],
        regNum: records[0]['registrationNumber'],
        className: records[0]['className'],
        date: DateTime.parse(records[0]['date']),
        isPresent: records[0]['isPresent'] == 1,
      );
    } else {
      return null;
    }
  }

  Future<AttendanceRecord?> getAttendanceRecordByName(
      String firstName, String lastName) async {
    final List<Map<String, dynamic>> records = await _database.query(
      'attendence_records',
      where: 'LOWER(firstName) = ? AND LOWER(lastName) = ?',
      whereArgs: [firstName.toLowerCase(), lastName.toLowerCase()],
      orderBy: 'date DESC',
      limit: 1,
    );

    if (records.isNotEmpty) {
      return AttendanceRecord(
        firstName: records[0]['firstName'],
        lastName: records[0]['lastName'],
        regNum: records[0]['registrationNumber'],
        className: records[0]['className'],
        date: DateTime.parse(records[0]['date']),
        isPresent: records[0]['isPresent'] == 1,
      );
    } else {
      return null;
    }
  }

  Future<void> saveLeaveRequest(String userEmail, String reason) async {
    await _database.insert('leave_requests', {
      'user_email': userEmail,
      'reason': reason,
    });
  }
}
