import 'package:flutter/material.dart';
import 'package:rtc/screens/jitsi/meeting_file.dart';
import 'package:uuid/uuid.dart';

class JitSi extends StatelessWidget {
  final meetingLink = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var uuid = Uuid();
    var meetingId = "${uuid.v4()}#rtckirshi";
    print(meetingId);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jitsi"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: meetingLink,
                decoration: InputDecoration(
                  hintText: "Enter meeting id",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MeetingFile(meetingId),
                          ),
                        );
                      },
                      child: const Text("Create")),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        if (meetingLink.text.contains("#rtckirshi")) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MeetingFile(meetingLink.text),
                            ),
                          );
                        }
                      },
                      child: const Text("Join")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
