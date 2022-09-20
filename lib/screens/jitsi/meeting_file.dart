import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MeetingFile extends StatelessWidget {
  final meetingID;
  MeetingFile(this.meetingID);
  @override
  Widget build(BuildContext context) {
    InAppWebViewController _webViewController;
    return Scaffold(
      appBar: AppBar(
        title: Text(meetingID),
        actions: [
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: meetingID));
              final snackBar = SnackBar(content: Text('Meeting ID copied!'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            icon: const Icon(Icons.copy),
          ),
        ],
      ),
      body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse("https://meet.jit.si/$meetingID"),
          ),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              mediaPlaybackRequiresUserGesture: false,
            ),
          ),
          onWebViewCreated: (InAppWebViewController controller) {
            _webViewController = controller;
          },
          androidOnPermissionRequest: (InAppWebViewController controller,
              String origin, List<String> resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          }),
    );
  }
}
