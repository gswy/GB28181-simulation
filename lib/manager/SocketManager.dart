
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gb28181/manager/StorageManager.dart';

/// 相机服务单例类
class SocketManager {

  static final SocketManager _instance = SocketManager._internal();

  factory SocketManager() => _instance;

  SocketManager._internal();

  late StorageManager _storage;
  RawDatagramSocket? _socket;

  /// 初始化
  Future init() async {
    _storage = StorageManager();
  }

  /// 设备注册
  Future<bool> register() async {
    int devicePort = _storage.getServerPort();
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, devicePort);
    _socket!.listen(_handleSocketEvent);
    bool resp = await _handleRegister();
    if (! resp) {
      _socket!.close();
    }

    Fluttertoast.showToast(msg: "UDP服务已启动");
    return true;
  }

  /// 监听UDP服务交互
  void _handleSocketEvent(RawSocketEvent event) {

  }

  /// SIP服务注册
  Future<bool> _handleRegister() async {
    String? serverID = _storage.getServerID();
    String? serverDomain = _storage.getServerDomain();
    String? serverIP = _storage.getServerIP();
    int serverPort = _storage.getServerPort();
    String? serverUsername = _storage.getServerUsername();
    String? serverPassword = _storage.getServerPassword();

    String? deviceID = _storage.getDeviceID();
    String? deviceDomain = _storage.getDeviceDomain();
    int devicePort = _storage.getDevicePort();

    if (serverID == null || serverDomain == null || serverIP == null) {
      Fluttertoast.showToast(msg: "SIP服务器未配置，请检查设置。");
      return false;
    }

    if (deviceID == null || deviceDomain == null) {
      Fluttertoast.showToast(msg: "设备信息未配置，请检查设置。");
    }


    String message = '''

''';

    return true;
  }


  /// 处理摄像头流
  void processCameraImage(CameraImage cameraImage) {

  }

}