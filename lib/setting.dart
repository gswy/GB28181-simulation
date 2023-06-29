import 'package:flutter/material.dart';
import 'package:gb28181/manager/StorageManager.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.title});
  final String title;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  /// 平台相关
  final TextEditingController _serverIDController = TextEditingController();
  final TextEditingController _serverDomainController = TextEditingController();
  final TextEditingController _serverIPController = TextEditingController();
  final TextEditingController _serverPortController = TextEditingController();
  final TextEditingController _serverUsernameController = TextEditingController();
  final TextEditingController _serverPasswordController = TextEditingController();

  /// 设备相关
  final TextEditingController _deviceIDController = TextEditingController();
  final TextEditingController _deviceDomainController = TextEditingController();
  final TextEditingController _devicePortController = TextEditingController();
  final TextEditingController _deviceHeartbeatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    /// 保存平台相关
    _serverIDController.text = StorageManager().getServerID() ?? "";
    _serverDomainController.text = StorageManager().getServerDomain() ?? "";
    _serverIPController.text = StorageManager().getServerIP() ?? "";
    _serverPortController.text = StorageManager().getServerPort().toString();
    _serverUsernameController.text = StorageManager().getServerUsername() ?? "";
    _serverPasswordController.text = StorageManager().getServerPassword() ?? "";

    /// 保存设备相关
    _deviceIDController.text = StorageManager().getDeviceID() ?? "";
    _deviceDomainController.text = StorageManager().getDeviceDomain() ?? "";
    _devicePortController.text = StorageManager().getDevicePort().toString();
    _deviceHeartbeatController.text = StorageManager().getDeviceHeartbeat().toString();
  }

  // 保存表单数据
  void _handleSave() {
      /// 保存平台相关
      StorageManager().setServerID(_serverIDController.text);
      StorageManager().setServerDomain(_serverDomainController.text);
      StorageManager().setServerIP(_serverIPController.text);
      StorageManager().setServerPort(int.parse(_serverPortController.text));
      StorageManager().setServerUsername(_serverUsernameController.text);
      StorageManager().setServerPassword(_serverPasswordController.text);

      /// 保存设备相关
      StorageManager().setDeviceID(_deviceIDController.text);
      StorageManager().setDeviceDomain(_deviceDomainController.text);
      StorageManager().setDevicePort(int.parse(_devicePortController.text));
      StorageManager().setDeviceHeartbeat(int.parse(_deviceHeartbeatController.text));
      Navigator.pop(context, true);
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
              _handleSave()
            }, icon: const Icon(Icons.save))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: ListView(
              children: [
                TextFormField(
                  controller: _serverIDController,
                  decoration: const InputDecoration(labelText: "平台ID"),
                  validator: (value) {},
                ),
                TextFormField(
                  controller: _serverDomainController,
                  decoration: const InputDecoration(labelText: "平台域"),
                  validator: (value) {},
                ),
                TextFormField(
                  controller: _serverIPController,
                  decoration: const InputDecoration(labelText: "平台IP"),
                  validator: (value) {},
                ),
                TextFormField(
                  controller: _serverPortController,
                  decoration: const InputDecoration(labelText: "平台端口"),
                  validator: (value) {},
                ),
                TextFormField(
                  controller: _serverUsernameController,
                  decoration: const InputDecoration(labelText: "平台用户"),
                  validator: (value) {},
                ),
                TextFormField(
                  controller: _serverPasswordController,
                  decoration: const InputDecoration(labelText: "平台密码"),
                  validator: (value) {

                  },
                ),

                TextFormField(
                  controller: _deviceIDController,
                  decoration: const InputDecoration(labelText: "设备ID"),
                  validator: (value) {},
                ),
                TextFormField(
                  controller: _deviceDomainController,
                  decoration: const InputDecoration(labelText: "设备域"),
                  validator: (value) {},
                ),
                TextFormField(
                  controller: _devicePortController,
                  decoration: const InputDecoration(labelText: "设备端口"),
                  validator: (value) {},
                ),
                TextFormField(
                  controller: _deviceHeartbeatController,
                  decoration: const InputDecoration(labelText: "设备心跳"),
                  validator: (value) {},
                ),
              ],
            ),
          ),
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
