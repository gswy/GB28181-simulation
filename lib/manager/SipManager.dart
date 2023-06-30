
/// SIP服务单例类
class SipManager {

  static final SipManager _instance = SipManager._internal();

  factory SipManager() => _instance;

  SipManager._internal();

  /// 初始化
  Future init() async {

  }
}