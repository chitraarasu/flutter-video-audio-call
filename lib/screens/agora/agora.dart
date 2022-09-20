import 'package:agora_uikit/agora_uikit.dart';
import "package:flutter/material.dart";

class Agora extends StatefulWidget {
  const Agora({Key? key}) : super(key: key);

  @override
  State<Agora> createState() => _AgoraState();
}

class _AgoraState extends State<Agora> {
  // Instantiate the client
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: "a96a7e9f55484811afeb885bf6587744",
      channelName: "test",
      tempToken:
          "007eJxTYCjPZQrOPnktS2Xuz7my135NeRc7YVusHL9VfJfMOfVVamIKDImWZonmqZZppqYmFiYWhoaJaalJFhamSWlmphbm5iYmlVs1k3+yaSdve/iBmZEBAkF8FoaS1OISBgYAOUAgpQ==",
    ),
  );

// Initialize the Agora Engine
  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

// Build your layout
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(client: client),
              AgoraVideoButtons(
                client: client,
                onDisconnect: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
