
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'manager/CameraManager.dart';
import 'manager/StorageManager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool ready = false;
  bool recording = false;
  CameraController? controller;

  // Socket客户端
  RawDatagramSocket? socket;

  // 定时任务（心跳处理）
  Timer? _heartbeat;

  // 初始化页面
  @override
  void initState() {
    super.initState();
    loadCamera();
  }

  /// 初始化相机
  void loadCamera() {
    var cameras = CameraManager().getCameras();
    var resolutions = CameraManager().getResolutions();

    controller = CameraController(cameras[StorageManager().getCamera()], resolutions[StorageManager().getResolution()]);
    controller!.initialize().then((val) {
      setState(() {ready = true;});
    });
  }

  // 开始推流
  void startRecording() async {
    socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 5060);
    socket!.listen(handleSocketEvent);
    // 开始注册
    if (! handleSipRegister()) {
      socket!.close();
      return;
    }

    Fluttertoast.showToast(msg: "UDP服务已启动");
    if (controller != null && controller!.value.isInitialized) {
      controller?.startImageStream((CameraImage image) {
        processCameraImage(image);
      });
      setState(() {
        recording = true;
      });
    }
  }


  // 监听UDP服务事件
  void handleSocketEvent(RawSocketEvent event) {
    // 收取数据
    if (event == RawSocketEvent.read) {
      handleSocketReceive(socket!.receive());
    }
    // 写入事件
    if (event == RawSocketEvent.write) {

    }
  }

  // 监听接收事件及数据
  void handleSocketReceive(Datagram? datagram) {
    if (datagram == null) return;
    print("接收到消息: ${String.fromCharCodes(datagram.data).trim()}");
  }

  // 停止推流
  void stopRecording() {
    if (socket == null) {
      setState(() {recording = false;});
      return;
    }
    socket!.close();
    socket = null;
    Fluttertoast.showToast(msg: "UDP服务已关闭");
    if (controller != null) {
      if (controller!.value.isInitialized) {
        controller?.stopImageStream();
        setState(() {recording = false;});
      }
    }
  }

  // 处理流
  void processCameraImage(CameraImage image) {
    // 获取图像数据
    final Uint8List bytes = image.planes[0].bytes;


  }

  // 心跳处理
  void handleHeartbeat() {
//     int second = _preferences!.getInt("heartbeat") ?? 10;
//     int num = 10000;
//     String? ipStr = _preferences!.getString("ip");
//     String? portStr = _preferences!.getString("port");
//     InternetAddress? address = InternetAddress.tryParse(_preferences!.getString("ip")!);
//     String heartbeatMessage = '''
// ''';
//     _heartbeat = Timer.periodic(Duration(seconds: second), (timer) {
//       socket!.send(heartbeatMessage.codeUnits, address!, int.parse(portStr!));
//     });
  }

  // 启动推流后，注册服务
  bool handleSipRegister() {
//     String? ipStr = _preferences!.getString("ip");
//     String? portStr = _preferences!.getString("port");
//     if (ipStr == null || portStr == null) {
//       return false;
//     }
//     InternetAddress? address = InternetAddress.tryParse(_preferences!.getString("ip")!);
//     if (address == null) {
//       Fluttertoast.showToast(msg: "注册IP错误！");
//       return false;
//     }
//     String registerMessage = '''
// \r\n
// ''';
//     socket!.send(registerMessage.codeUnits, address, int.parse(portStr));
    return true;
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
              Navigator.pushNamed(context, "/about")
            }, icon: const Icon(Icons.question_mark)),
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
                  items: CameraManager().getCameraWidgets().toList(),
                  value: StorageManager().getCamera(),
                  onChanged: (val) async {
                    if (controller == null) return;
                    StorageManager().setCamera(val);
                    await controller!.setDescription(CameraManager().getCameras()[val]);
                    stopRecording();
                    Fluttertoast.showToast(msg: "切换摄像头后，请重新推流");
                  }),
              Container(height: 20),
              DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: '选择清晰度'),
                  items: CameraManager().getResolutionWidgets().toList(),
                  value: StorageManager().getResolution(),
                  onChanged: (val) async {
                    if (controller == null) return;
                    setState(() {ready = false;});

                    // 停止推流并提示
                    stopRecording();
                    Fluttertoast.showToast(msg: "切换清晰度后，请重新推流");
                    // 停止原有相机
                    await controller!.dispose();
                    StorageManager().setResolution(val);

                    int selectCamera = StorageManager().getCamera();
                    int selectResolution = StorageManager().getResolution();

                    List<CameraDescription> cameras = CameraManager().getCameras();
                    List<ResolutionPreset> resolutions = CameraManager().getResolutions();

                    // 初始化新相机
                    controller = CameraController(cameras[selectCamera], resolutions[selectResolution]);
                    await controller!.initialize();
                    setState(() {ready = true;});
                  }),
              Container(height: 20),
              recording ? ElevatedButton(onPressed: () {
                stopRecording();
              }, child: const Text("停止注册")) : ElevatedButton(onPressed: () {
                startRecording();
              }, child: const Text("信令注册"))
            ],
          ),
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}