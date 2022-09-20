import 'package:flutter/material.dart';
import 'package:rtc/models/meeting_details.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import 'meeting_page.dart';

class JoinScreen extends StatefulWidget {
  final MeetingDetail meetingDetail;
  JoinScreen({required this.meetingDetail});

  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String userName = "";

  formUi(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            FormHelper.inputFieldWidget(
              context,
              "userId",
              "Enter your Name",
              (val) {
                if (val.isEmpty) {
                  return "Name can't be empty";
                }
                return null;
              },
              (data) {
                userName = data;
              },
              borderRadius: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: FormHelper.submitButton(
                    "Join",
                    () {
                      if (validateAndSave()) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return MeetingPage(
                            meetingID: widget.meetingDetail.id,
                            name: userName,
                            meetingDetail: widget.meetingDetail,
                          );
                        }));
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Join meeting"),
      ),
      body: Form(
        key: globalKey,
        child: formUi(context),
      ),
    );
  }
}
