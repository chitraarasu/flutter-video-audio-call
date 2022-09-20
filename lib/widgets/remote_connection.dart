import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';

class RemoteConnection extends StatefulWidget {
  final RTCVideoRenderer renderer;
  final Connection connection;
  RemoteConnection({required this.renderer, required this.connection});

  @override
  State<RemoteConnection> createState() => _RemoteConnectionState();
}

class _RemoteConnectionState extends State<RemoteConnection> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          child: RTCVideoView(
            widget.renderer,
            mirror: false,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        ),
        Container(
          color: widget.connection.videoEnabled!
              ? Colors.transparent
              : Colors.blueGrey[900],
          child: Text(
            widget.connection.videoEnabled! ? '' : widget.connection.name!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
        Positioned(
          bottom: 10.0,
          left: 10.0,
          child: Container(
            padding: EdgeInsets.all(5),
            color: Colors.black,
            child: Row(
              children: [
                Text(
                  widget.connection.name!,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  widget.connection.audioEnabled! ? Icons.mic : Icons.mic_off,
                  color: Colors.white,
                  size: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
