
import 'package:shared_preferences/shared_preferences.dart';

/// 存储服务单例类
class StorageManager {

  static final StorageManager _instance = StorageManager._internal();

  factory StorageManager() => _instance;

  StorageManager._internal();

  /// 存储实例
  late SharedPreferences _preferences;

  /// 初始化
  Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// 保存SIP服务器ID
  setServerID(String id) {
    _preferences.setString("server-id", id);
  }

  /// 获取SIP服务器ID
  String? getServerID() {
    return _preferences.getString("server-id");
  }

  /// 保存设备ID
  setDeviceID(String id) {
    _preferences.setString("device-id", id);
  }

  /// 获取设备ID
  String? getDeviceID() {
    return _preferences.getString("device-id");
  }

  /// 保存SIP服务器域
  setServerDomain(String domain) {
    _preferences.setString("server-domain", domain);
  }

  /// 获取SIP服务器域
  String? getServerDomain() {
    return _preferences.getString("server-domain");
  }

  /// 保存SIP服务器域
  setDeviceDomain(String domain) {
    _preferences.setString("device-domain", domain);
  }

  /// 获取SIP服务器域
  String? getDeviceDomain() {
    return _preferences.getString("device-domain");
  }

  /// 保存SIP服务器IP
  setServerIP(String ip) {
    _preferences.setString("server-ip", ip);
  }

  /// 获取SIP服务器IP
  String? getServerIP() {
    return _preferences.getString("server-ip");
  }

  /// 保存SIP服务器端口
  setServerPort(int port) {
    _preferences.setString("server-port", port.toString());
  }

  /// 获取SIP服务器端口
  int getServerPort() {
    String? port = _preferences.getString("server-port");
    if (port == null) return 9999;
    return int.parse(port);
  }

  /// 保存设备端口
  setDevicePort(int port) {
    _preferences.setString("device-port", port.toString());
  }

  /// 获取设备端口
  int getDevicePort() {
    String? port = _preferences.getString("device-port");
    if (port == null) return 5060;
    return int.parse(port);
  }

  /// 保存设备心跳
  setDeviceHeartbeat(int second) {
    _preferences.setString("device-heartbeat", second.toString());
  }

  /// 获取设备心跳
  int getDeviceHeartbeat() {
    String? heartbeat = _preferences.getString("device-heartbeat");
    if (heartbeat == null) return 10;
    return int.parse(heartbeat);
  }

  /// 保存SIP服务器注册用户名
  setServerUsername(String username) {
    _preferences.setString("server-username", username);
  }

  /// 获取SIP服务器注册用户名
  String? getServerUsername() {
    return _preferences.getString("server-username");
  }

  /// 保存SIP服务器注册用户名
  setServerPassword(String password) {
    _preferences.setString("server-password", password);
  }

  /// 获取SIP服务器注册用户名
  String? getServerPassword() {
    return _preferences.getString("server-password");
  }

}