
import 'dart:html';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// 相机服务单例类
class CameraManager {

  static final CameraManager _instance = CameraManager._internal();

  factory CameraManager() => _instance;

  CameraManager._internal();

  /// 相机列表实例
  late List<CameraDescription> _cameras;

  /// 初始化
  Future init() async {
    // 获取相机数量
    _cameras = await availableCameras();
  }

  /// 获取分辨率列表
  List<DropdownMenuItem> getResolutions() {
    return [
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
  }

  /// 获取摄像头列表
  List<DropdownMenuItem> getCameras() {
    // 设置摄像头列表
    List<DropdownMenuItem> cameraLists = [];
    int key = 0;
    for (var description in _cameras) {
      cameraLists.add(DropdownMenuItem(value: key, child: Text("摄像头：${description.name}")));
      key ++;
    }
    return cameraLists;
  }

}