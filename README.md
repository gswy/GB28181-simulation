# GB28181-simulation

[![](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/gswy/GB28181-simulation/blob/main/LICENSE)

## 项目简介
项目中需要使用GB28181平台级联方式对接，使用了`WVP`此类开源软件，苦于手头没有现成的摄像头抓包测试，于是此项目诞生了。该
项目采用Flutter开发，页面简单，可快速上手或参考使用。

## 项目计划
项目计划前缀图标展示，其中⚠️代表开发中，❌代表未实现，✅代表已实现。

- ✅ 整体页面搭建，设置页信令配置。
- ✅ 摄像头前后切换，清晰度配置。
- ⚠️ UDP客户端实现。
  - ⚠️ 设备注册至SIP服务器。
  - ⚠️ 设备心跳发送至SIP服务器。
  - ⚠️ SIP服务器查询设备通道。
  - ⚠️ SIP服务器请求推流。
