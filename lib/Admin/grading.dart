import 'package:attendence_sys/AppBar/CustomAppBar.dart';
import 'package:attendence_sys/Student/databaseHelper.dart';
import 'package:attendence_sys/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class grading extends StatefulWidget {
  const grading({super.key});

  @override
  State<grading> createState() => _gradingState();
}

class _gradingState extends State<grading> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _registrationNumberController = TextEditingController();
  TextEditingController _classNameController = TextEditingController();

  TextEditingController _dateController = TextEditingController();

  bool _isEditable = true;
  bool _isPresent = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(height: 170),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0, top: 15.0, bottom: 0),
                child: Text(
                  "Automatically generate grading system.",
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 89, 48, 170),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      buildInputField(
                        controller: _firstNameController,
                        hintText: 'First Name',
                        enabled: _isEditable,
                      ),
                      SizedBox(height: 2),
                      buildInputField(
                        controller: _lastNameController,
                        hintText: 'Last Name',
                        enabled: _isEditable,
                      ),
                      SizedBox(height: 2),
                      buildInputField(
                        controller: _registrationNumberController,
                        hintText: 'Registration Number',
                        enabled: _isEditable,
                      ),
                      SizedBox(height: 25),
                      SizedBox(
                        height: 40,
                        width: 140,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xffc780ff),
                          ),
                          child: Text(
                            "Generate",
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffdde6ed),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String firstName = _firstNameController.text;
                              String lastName = _lastNameController.text;
                              String regNumber =
                                  _registrationNumberController.text;
                              String className = _classNameController.text;
                              String date = _dateController.text;
                              await checkAndUpdateFields(firstName, lastName);
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 70),
                      Text(
                        " GRADE IS: ",
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 89, 48, 170)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkAndUpdateFields(String firstName, String lastName) async {
    //print('Checking for: $firstName $lastName on $regNum');

    final existingRecord = await _databaseHelper.getAttendanceRecordByReg(
      firstName,
      lastName,
      //regNum,
    );

    if (existingRecord != null) {
      setState(() {
        _isPresent = existingRecord.isPresent;
        print('Data found');
      });
    } else {
      Utils().toastMessage('No data found.');

      setState(() {
        _isEditable = true;
        _isPresent = true; // Reset to default value
      });
    }
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String hintText,
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 21, 9),
      child: Container(
        width: 326,
        height: 50,
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
        child: TextFormField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 8.0, left: 15),
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class GradingLogic {
  static String calculateGrade(int attendedDays) {
    if (attendedDays >= 26) {
      return 'A';
    } else if (attendedDays >= 20) {
      return 'B';
    } else if (attendedDays >= 15) {
      return 'C';
    } else if (attendedDays >= 10) {
      return 'D';
    } else {
      return 'F';
    }
  }
}
