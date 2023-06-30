
import 'dart:io';

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
}