import 'package:wukongimfluttersdk/model/wk_message_content.dart';

/// 资质查看信令消息类型（自定义类型，避开 SDK 内置的 <=99）
const int kQualificationContentType = 1001;

/// 信令动作
class QualificationAction {
  static const String apply = 'apply'; // 申请查看
  static const String agree = 'agree'; // 同意
  static const String reject = 'reject'; // 拒绝
}

/// 资质项 key（与 EditReportReq / SafeReportModel 字段对应）
class QualificationItem {
  static const String health = 'health'; // 恋爱四项 -> healthPic
  static const String tax = 'tax'; // 个人纳税 -> payTaxesPic
  static const String credit = 'credit'; // 个人信用 -> creditPic

  /// 资质项中文名
  static String label(String key) {
    switch (key) {
      case health:
        return '恋爱四项';
      case tax:
        return '个人纳税';
      case credit:
        return '个人信用';
      default:
        return '资质信息';
    }
  }

  /// 多个资质项拼接展示
  static String labels(List<String> keys) {
    if (keys.isEmpty) return '资质信息';
    return keys.map(label).join('、');
  }
}

/// 资质查看信令自定义消息
///
/// 通过 WuKongIM 个人频道实时收发，一条 [reqId] 对应一次完整的
/// 申请 -> 同意/拒绝 流程。
class QualificationContent extends WKMessageContent {
  /// 动作：apply / agree / reject
  String action;

  /// 一次申请的唯一ID，用于把后续 agree/reject 关联回 apply
  String reqId;

  /// 申请查看的资质项
  List<String> items;

  /// 发起方用户ID
  String applicantId;

  /// 发起方昵称
  String applicantName;

  QualificationContent({
    this.action = '',
    this.reqId = '',
    this.items = const [],
    this.applicantId = '',
    this.applicantName = '',
  }) {
    contentType = kQualificationContentType;
  }

  @override
  Map<String, dynamic> encodeJson() {
    return {
      'action': action,
      'reqId': reqId,
      'items': items,
      'applicantId': applicantId,
      'applicantName': applicantName,
    };
  }

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    action = readString(json, 'action');
    reqId = readString(json, 'reqId');
    applicantId = readString(json, 'applicantId');
    applicantName = readString(json, 'applicantName');
    final rawItems = json['items'];
    items = rawItems is List
        ? rawItems.map((e) => e.toString()).toList()
        : <String>[];
    return this;
  }

  @override
  String displayText() {
    switch (action) {
      case QualificationAction.apply:
        return '[资质查看申请]';
      case QualificationAction.agree:
        return '[已同意资质查看]';
      case QualificationAction.reject:
        return '[已拒绝资质查看]';
      default:
        return '[资质消息]';
    }
  }
}
