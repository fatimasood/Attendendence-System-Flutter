import 'package:attendence_sys/Admin/UpdateRecord.dart';
import 'package:attendence_sys/AppBar/CustomAppBar.dart';
import 'package:attendence_sys/Student/MarkAt.dart';
import 'package:attendence_sys/Student/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ManagerHome extends StatefulWidget {
  const ManagerHome({Key? key}) : super(key: key);

  @override
  _ManagerHomeState createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
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
      attendanceRecords = records.cast<AttendanceRecord>();
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
                padding:
                    const EdgeInsets.only(left: 20, top: 15.0, bottom: 5.8),
                child: Text(
                  "Welcome to the Manager Portal. Here is all your task with necessary info. ",
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
                    height: 100,
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
                          '${record.firstName} ${record.lastName}',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${_formatDate(record.date)}'),
                            Text(
                              'Status: ${record.isPresent ? 'To DO' : 'In Progress'}',
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blueAccent,
                                size: 20,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateRecord(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MarkAttendence(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color(0xffc780ff),
      ),
    );
  }
}
