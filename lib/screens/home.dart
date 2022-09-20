import 'package:flutter/material.dart';
import 'package:rtc/screens/jitsi/jitsi.dart';
import 'package:rtc/screens/webrtc/webrtc.dart';

import 'agora/agora.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RTC"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JitSi(),
                  ),
                );
              },
              child: const Text("Jitsi"),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebRTC(),
                  ),
                );
              },
              child: const Text("Web RTC"),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Agora(),
                  ),
                );
              },
              child: const Text("Agora"),
            ),
          ],
        ),
      ),
    );
  }
}
