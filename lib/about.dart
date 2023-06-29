import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key, required this.title});

  final String title;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
            child: const Text("        GB28181模拟摄像头软件，使用技术栈为Flutter，测试平台为wvp-gb28181-pro。此APP用于模拟海康、大华、科达等摄像头软件。"
                "使用前，请先阅读《公共安全视频监控联网系统信息传输、交换、控制技术要求》，软件开发规范为 GB/T 28181-2016，请先确定平台是否支持。"
                "软件仅支持UDP传输的SIP协议，流媒体格式为RTP封装的h.264。"),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
            child: const Text("        本软件完全开源免费，使用较为宽松的开源协议MIT，如有问题请在 https://github.com/gswy/GB28181-simulation 中提交issue。"),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
            child: const Text("        有其他问题的，可加作者微信：gswanyun（请注明来意）。"),
          ),
        ],
      )
    );
  }
}
