import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gb28181/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        "/setting": (context) => const SettingPage(title: "设置")
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool ready = false;
  bool recording = false;
  List<CameraDescription> cameras = [];
  CameraController? controller;

  // 存储数据
  SharedPreferences? _preferences;

  // 初始化页面
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        _preferences = value;
      });
    });
    availableCameras().then((value) {
      cameras = value;
      controller = CameraController(cameras[1], ResolutionPreset.low);
      controller?.initialize();
      setState(() {
        ready = true;
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  // 开始推流
  void startRecording() {
    if (controller != null && controller!.value.isInitialized) {
      controller?.startImageStream((CameraImage image) {
        processCameraImage(image);
      });
      setState(() {
        recording = true;
      });
    }
  }

  // 停止推流
  void stopRecording() {
    if (controller != null && controller!.value.isInitialized) {
      controller?.stopImageStream();
      setState(() {
        recording = false;
      });
    }
  }

  // 处理流
  void processCameraImage(CameraImage image) {

    print("摄像头流: ${image}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => {
            Navigator.pushNamed(context, "/setting").then((value) {
              if (value != null) {
                Fluttertoast.showToast(msg: "已更新配置，请重新推流");
              }
            })
          }, icon: const Icon(Icons.settings))
        ],
      ),
      body: ListView(
        children: [
          ready ? CameraPreview(controller!) :
          const Text("加载摄像头中..."),
          Container(height: 50),
          recording ? ElevatedButton(onPressed: () {
            stopRecording();
          }, child: const Text("停止推流")) : ElevatedButton(onPressed: () {
            startRecording();
          }, child: const Text("开始推流"))
        ],
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
