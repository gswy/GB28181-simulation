
import 'package:flutter/material.dart';
import 'package:gb28181/about.dart';
import 'package:gb28181/manager/CameraManager.dart';
import 'package:gb28181/manager/SocketManager.dart';
import 'package:gb28181/manager/StorageManager.dart';
import 'package:gb28181/setting.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager().init();
  await CameraManager().init();
  await SocketManager().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GB28181',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const HomePage(title: "首页"),
        "/setting": (context) => const SettingPage(title: "设置"),
        "/about": (context) => const AboutPage(title: "关于"),
      },
    );
  }
}


