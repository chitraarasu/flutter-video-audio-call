import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';
import 'package:rtc/models/meeting_details.dart';
import 'package:rtc/widgets/control_panel.dart';
import 'package:rtc/widgets/remote_connection.dart';

import '../../api/meeting_api.dart';
import '../../utils/user.utils.dart';
import '../home.dart';

class MeetingPage extends StatefulWidget {
  final String? meetingID;
  final String? name;
  final MeetingDetail meetingDetail;

  MeetingPage({this.meetingID, this.name, required this.meetingDetail});

  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final _localrenderer = RTCVideoRenderer();
  final Map<String, dynamic> mediaConstraints = {
    "audio": true,
    "video": true,
  };

  bool isConnectionFailed = false;
  WebRTCMeetingHelper? meetingHelper;

  void onAudioToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleAudio();
      });
    }
  }

  void onVideoToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleVideo();
      });
    }
  }

  void handleReconnect() {
    if (meetingHelper != null) {
      meetingHelper!.reconnect();
    }
  }

  void startMeeting() async {
    final String userId = await loadUserId();
    print(MEETING_API_URL.split('/api/meeting').first);
    meetingHelper = WebRTCMeetingHelper(
      url: MEETING_API_URL.split('/api/meeting').first,
      meetingId: widget.meetingDetail.id,
      userId: userId,
      name: widget.name,
    );

    MediaStream _localStream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localrenderer.srcObject = _localStream;
    meetingHelper!.stream = _localStream;

    meetingHelper!.on(
      "open",
      context,
      (ev, context) {
        setState(() {
          isConnectionFailed = false;
        });
      },
    );

    meetingHelper!.on(
      "connection",
      context,
      (ev, context) {
        setState(() {
          isConnectionFailed = false;
        });
      },
    );

    meetingHelper!.on(
      "user-left",
      context,
      (ev, context) {
        setState(() {
          isConnectionFailed = false;
        });
      },
    );

    meetingHelper!.on(
      "video-toggle",
      context,
      (ev, context) {
        setState(() {});
      },
    );

    meetingHelper!.on(
      "audio-toggle",
      context,
      (ev, context) {
        setState(() {});
      },
    );

    meetingHelper!.on(
      "meeting-ended",
      context,
      (ev, context) {
        onMeetingEnd();
      },
    );

    meetingHelper!.on(
      "connection-setting-changed",
      context,
      (ev, context) {
        setState(() {
          isConnectionFailed = false;
        });
      },
    );

    meetingHelper!.on(
      "stream-changed",
      context,
      (ev, context) {
        setState(() {
          isConnectionFailed = false;
        });
      },
    );

    setState(() {});
  }

  initRenderers() async {
    await _localrenderer.initialize();
  }

  @override
  void initState() {
    super.initState();
    initRenderers();
    startMeeting();
  }

  @override
  void deactivate() {
    super.deactivate();
    _localrenderer.dispose();
    if (meetingHelper != null) {
      meetingHelper!.destroy();
      meetingHelper = null;
    }
  }

  void onMeetingEnd() {
    if (meetingHelper != null) {
      meetingHelper!.endMeeting();
      meetingHelper = null;
      goToHomePage();
    }
  }

  _buildMeetingRoom() {
    return Stack(
      children: [
        meetingHelper != null && meetingHelper!.connections.isNotEmpty
            ? GridView.count(
                crossAxisCount: meetingHelper!.connections.length < 3 ? 1 : 2,
                children:
                    List.generate(meetingHelper!.connections.length, (index) {
                  return Padding(
                    padding: EdgeInsets.all(1),
                    child: RemoteConnection(
                      renderer: meetingHelper!.connections[index].renderer,
                      connection: meetingHelper!.connections[index],
                    ),
                  );
                }),
              )
            : Center(
                child: Text(
                  "Waiting for participants to join the meeting",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 24,
                  ),
                ),
              ),
        Positioned(
          bottom: 10,
          right: 0,
          child: SizedBox(
            width: 150,
            height: 200,
            child: RTCVideoView(_localrenderer),
          ),
        )
      ],
    );
  }

  bool isVideoEnabled() {
    return meetingHelper != null ? meetingHelper!.videoEnabled! : false;
  }

  bool isAudioEnabled() {
    return meetingHelper != null ? meetingHelper!.audioEnabled! : false;
  }

  void goToHomePage() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Home()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: _buildMeetingRoom(),
      bottomNavigationBar: ControlPanel(
        onAudioToggle: onAudioToggle,
        onVideoToggle: onVideoToggle,
        videoEnabled: isVideoEnabled(),
        audioEnabled: isAudioEnabled(),
        isConnectionFailed: isConnectionFailed,
        onReconnect: handleReconnect,
        onMeetingEnd: onMeetingEnd,
      ),
    );
  }
}
