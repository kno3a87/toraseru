import 'package:flutter/material.dart';
import 'package:toraseru/camera_page.dart';
import 'package:toraseru/web_rtc_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}


class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabBar'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "カメラだよ",
              ),
              Tab(
                text: "WebTRCだよ",
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CameraPage(),
            WebRTCPage(),
          ],
        ),
      ),
    );
  }
}