import 'package:attendence_sys/AppBar/CustomAppBar.dart';
import 'package:attendence_sys/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaveReq extends StatefulWidget {
  const LeaveReq({super.key});

  @override
  State<LeaveReq> createState() => _LeaveReqState();
}

class _LeaveReqState extends State<LeaveReq> {
  TextEditingController _paragraphController = TextEditingController();
  int maxLines = 4;
  bool isDisabled = false;
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
                  "Write reason briefly in a 2 to 3 lines for Leave.",
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
                padding: EdgeInsets.all(20),
                child: Container(
                  width: 340,
                  height: 180,
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          enabled: !isDisabled,
                          controller: _paragraphController,
                          onChanged: (text) {
                            int lines = '\n'.allMatches(text).length + 1;
                            if (lines >= 4) {
                              setState(() => isDisabled = true);
                              setState(() {
                                Utils()
                                    .toastMessage('Write your reason shortly!');
                              });
                            }
                          },
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'Reason.....',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  print('User input: ${_paragraphController.text}');
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
