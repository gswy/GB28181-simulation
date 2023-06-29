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

  // 摄像头清晰度
  List<DropdownMenuItem> resolution = [
    const DropdownMenuItem(
      value: ResolutionPreset.low,
      child: Text("240p (320x240)"),
    ),
    const DropdownMenuItem(
      value: ResolutionPreset.medium,
      child: Text("480p (640x480)"),
    ),
    const DropdownMenuItem(
      value: ResolutionPreset.high,
      child: Text("720p (1280x720)"),
    ),
    const DropdownMenuItem(
      value: ResolutionPreset.veryHigh,
      child: Text("1080p (1920x1080)"),
    ),
    const DropdownMenuItem(
      value: ResolutionPreset.ultraHigh,
      child: Text("2160p (3840x2160)"),
    ),
    const DropdownMenuItem(
      value: ResolutionPreset.max,
      child: Text("原画"),
    ),
  ];

  // 切换前后
  List<DropdownMenuItem> cameraList = [];

  int selectCamera = 0;
  ResolutionPreset selectResolution = ResolutionPreset.low;

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
      // 设置摄像头列表
      List<DropdownMenuItem> cameraLists = [];
      int key = 0;
      for (var description in value) {
        cameraLists.add(DropdownMenuItem(value: key, child: Text("摄像头：${description.name}")));
        key ++;
      }

      setState(() {
        cameraList = cameraLists;
      });

      controller = CameraController(cameras[selectCamera], selectResolution);
      controller!.initialize().then((val) {
        setState(() {
          ready = true;
        });
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
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ready ? CameraPreview(controller!) :
            const Text("加载摄像头中..."),
            Container(height: 50),
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: '切换摄像头'),
              items: cameraList,
              value: 0,
              onChanged: (val) async {
                if (controller == null) return;
                await controller!.setDescription(cameras[val]);
                selectCamera = val;
                stopRecording();
                Fluttertoast.showToast(msg: "切换摄像头后，请重新推流");
              }),
            Container(height: 20),
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: '选择清晰度'),
              items: resolution.toList(),
              value: ResolutionPreset.low,
              onChanged: (val) async {
                if (controller == null) return;
                setState(() {
                  ready = false;
                });
                stopRecording();
                Fluttertoast.showToast(msg: "切换清晰度后，请重新推流");
                // 停止原有相机
                await controller!.dispose();
                controller = CameraController(cameras[selectCamera], val);
                selectResolution = val;
                await controller!.initialize();
                setState(() {
                  ready = true;
                });
              }),
            Container(height: 20),
            recording ? ElevatedButton(onPressed: () {
              stopRecording();
            }, child: const Text("停止推流")) : ElevatedButton(onPressed: () {
              startRecording();
            }, child: const Text("开始推流"))
          ],
        ),
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
