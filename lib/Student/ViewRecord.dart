import 'package:attendence_sys/AppBar/CustomAppBar.dart';
import 'package:attendence_sys/Student/MarkAt.dart';
import 'package:attendence_sys/Student/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ViewRecord extends StatefulWidget {
  const ViewRecord({Key? key}) : super(key: key);

  @override
  _ViewRecordState createState() => _ViewRecordState();
}

class _ViewRecordState extends State<ViewRecord> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  List<AttendanceRecord> attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    _loadAttendanceRecords();
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _loadAttendanceRecords() async {
    final records = await _databaseHelper.getAllAttendanceRecords();
    setState(() {
      attendanceRecords = records;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(height: 170),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 5.8),
                child: Text(
                  "Here is your all attendence record ",
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 89, 48, 170),
                    ),
                  ),
                ),
              ),
              for (var record in attendanceRecords)
                Container(
                  padding: const EdgeInsets.fromLTRB(22, 12, 21, 9),
                  child: Container(
                    width: 340,
                    height: 82,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(248, 238, 238, 238),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3f000000),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ListTile(
                        title: Text(
                          'Date: ${_formatDate(record.date)}',
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                            'Present Status: ${record.isPresent ? 'Present' : 'Absent'}'),
                        trailing:
                            DateTime.now().difference(record.date).inHours > 24
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          // Add your edit logic here
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          // Add your delete logic here
                                        },
                                      ),
                                    ],
                                  )
                                : null,
                        // Add more fields as needed
                      ),
                    ),
                  ),
                ),
              // Add more widgets as needed
            ],
          ),
        ),
      ),
    );
  }
}
