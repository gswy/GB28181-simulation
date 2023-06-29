
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Socket客户端
  RawDatagramSocket? socket;

  // 定时任务（心跳处理）
  Timer? _heartbeat;

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
      setState(() {
        recording = false;
      });
      return;
    }
    socket!.close();
    socket = null;
    Fluttertoast.showToast(msg: "UDP服务已关闭");
    if (controller != null) {
      if (controller!.value.isInitialized) {
        controller?.stopImageStream();
        setState(() {
          recording = false;
        });
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
    int second = _preferences!.getInt("heartbeat") ?? 10;
    int num = 10000;
    String? ipStr = _preferences!.getString("ip");
    String? portStr = _preferences!.getString("port");
    InternetAddress? address = InternetAddress.tryParse(_preferences!.getString("ip")!);
    String heartbeatMessage = '''
MESSAGE sip:62120000002005001024@6212000000 SIP/2.0
From: <sip:62120000002005000000@6212000000>;tag=3969513187
To: <sip:62120000002005001024@6212000000>
Call-ID: 3425595801
CSeq: 1129861734 MESSAGE
Via: SIP/2.0/UDP 192.168.0.121:8888;rport;branch=z9hG4bK756439861
Max-Forwards: 70	
Content-Type: application/MANSCDP+xml	
Content-Length: 145

<?xml version="1.0" ?>
<Notify>
<CmdType>Keepalive</CmdType>
<SN>736</SN>
<DeviceID>62120000002005000000</DeviceID>
<Status>OK</Status>
</Notify>
''';
    _heartbeat = Timer.periodic(Duration(seconds: second), (timer) {
      socket!.send(heartbeatMessage.codeUnits, address!, int.parse(portStr!));
    });
  }

  // 启动推流后，注册服务
  bool handleSipRegister() {
    String? ipStr = _preferences!.getString("ip");
    String? portStr = _preferences!.getString("port");
    if (ipStr == null || portStr == null) {
      return false;
    }
    InternetAddress? address = InternetAddress.tryParse(_preferences!.getString("ip")!);
    if (address == null) {
      Fluttertoast.showToast(msg: "注册IP错误！");
      return false;
    }
    String registerMessage = '''
REGISTER sip:62120000002005001024@6212000000 SIP/2.0
Via: SIP/2.0/UDP $ipStr:$portStr;rport;branch=z9hG4bK756439861
From: <sip:62120000002005000000@6212000000>;tag=3969513187
To: <sip:62120000002005001024@6212000000>
Call-ID: 3425595801
CSeq: 1 REGISTER
Contact: <sip:62120000002005000000@$ipStr:9999;line=e74829c82eb7149>
Max-Forwards: 70
Expires: 3600
Content-Length: 0
\r\n
''';
    socket!.send(registerMessage.codeUnits, address, int.parse(portStr));
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
              }, child: const Text("停止注册")) : ElevatedButton(onPressed: () {
                startRecording();
              }, child: const Text("信令注册"))
            ],
          ),
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}