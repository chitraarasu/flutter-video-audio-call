import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:rtc/api/meeting_api.dart';
import 'package:rtc/models/meeting_details.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import 'join_screen.dart';

class WebRTC extends StatefulWidget {
  const WebRTC({Key? key}) : super(key: key);

  @override
  State<WebRTC> createState() => _WebRTCState();
}

class _WebRTCState extends State<WebRTC> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String meetingId = "";

  formUi(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to WebRC Meeting App",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FormHelper.inputFieldWidget(
              context,
              "meetingId",
              "Enter your Meeting Id",
              (val) {
                if (val.isEmpty) {
                  return "Meeting Id can't be empty";
                }
                return null;
              },
              (data) {
                meetingId = data;
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
                    "Join Meeting",
                    () {
                      if (validateAndSave()) {
                        validateMeeting(meetingId);
                      }
                    },
                  ),
                ),
                Flexible(
                  child: FormHelper.submitButton(
                    "Start Meeting",
                    () async {
                      var response = await startMeeting();
                      print(response?.body);
                      final body = json.decode(response!.body);

                      final meetId = body["data"];
                      Clipboard.setData(ClipboardData(text: meetId ?? ""));
                      validateMeeting(meetId);
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

  void validateMeeting(String meetingId) async {
    try {
      Response? response = await joinMeeting(meetingId);
      print(response!.body);
      var data = json.decode(response.body);
      final meetingDetails = MeetingDetail.fromJson(data["data"]);
      goToJoinScreen(meetingDetails);
    } catch (err) {
      FormHelper.showSimpleAlertDialog(
          context, "Meeting App", "Invalid Meeting Id", "OK", () {
        Navigator.of(context).pop();
      });
    }
  }

  goToJoinScreen(MeetingDetail meetingDetail) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => JoinScreen(
                  meetingDetail: meetingDetail,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebRTC"),
      ),
      body: Form(
        key: globalKey,
        child: formUi(context),
      ),
    );
  }
}
