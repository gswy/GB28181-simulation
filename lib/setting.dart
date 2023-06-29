import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.title});
  final String title;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _domainController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _heartbeatController = TextEditingController();
  final TextEditingController _retryController = TextEditingController();
  SharedPreferences? _preferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        _preferences = value;
      });
      _idController.text = value.getString("id") ?? "";
      _domainController.text = value.getString("domain") ?? "";
      _ipController.text = value.getString("ip") ?? "";
      _portController.text = value.getString("port") ?? "";
      _usernameController.text = value.getString("username") ?? "";
      _passwordController.text = value.getString("password") ?? "";
      _heartbeatController.text = value.getString("heartbeat") ?? "10";
      _retryController.text = value.getString("retry") ?? "30";
    });
  }

  // 保存表单数据
  void _handleSave() async {
      if (_preferences != null) {
        _preferences!.setString("id", _idController.text);
        _preferences!.setString("domain", _domainController.text);
        _preferences!.setString("ip", _ipController.text);
        _preferences!.setString("port", _portController.text);
        _preferences!.setString("username", _usernameController.text);
        _preferences!.setString("password", _passwordController.text);
        _preferences!.setString("heartbeat", _heartbeatController.text);
        _preferences!.setString("retry", _retryController.text);
        Navigator.pop(context, true);
      }
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
                  controller: _idController,
                  decoration: const InputDecoration(labelText: "平台ID"),
                  validator: (value) {},
                ),
                TextFormField(
                  controller: _domainController,
                  decoration: const InputDecoration(labelText: "平台域"),
                  validator: (value) {},
                ),
                TextFormField(
                  controller: _ipController,
                  decoration: const InputDecoration(labelText: "平台IP"),
                  validator: (value) {},
                ),
                TextFormField(
                  controller: _portController,
                  decoration: const InputDecoration(labelText: "平台端口"),
                  validator: (value) {},
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: "用户名"),
                  validator: (value) {},
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "密码"),
                  validator: (value) {

                  },
                ),
                TextFormField(
                  controller: _heartbeatController,
                  decoration: const InputDecoration(labelText: "心跳间隔"),
                  validator: (value) {},
                ),
                TextFormField(
                  controller: _retryController,
                  decoration: const InputDecoration(labelText: "重试间隔"),
                  validator: (value) {},
                ),
              ],
            ),
          ),
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
