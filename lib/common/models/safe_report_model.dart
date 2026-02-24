class SafeReportModel {
  String? createBy;
  String? createTime;
  String? creditPic;
  String? healthPic;
  String? id;
  int? isCredit;
  int? isHealth;
  int? isPayTaxes;
  String? payTaxesPic;
  int? isReal;
  String? realPic;
  String? updateBy;
  String? updateTime;

  SafeReportModel({
    this.createBy,
    this.createTime,
    this.creditPic,
    this.healthPic,
    this.id,
    this.isCredit,
    this.isHealth,
    this.isPayTaxes,
    this.isReal,
    this.payTaxesPic,
    this.realPic,
    this.updateBy,
    this.updateTime,
  });

  factory SafeReportModel.fromJson(Map<String, dynamic> json) {
    return SafeReportModel(
      createBy: json['createBy'] as String?,
      createTime: json['createTime'] as String?,
      creditPic: json['creditPic'] as String?,
      healthPic: json['healthPic'] as String?,
      id: json['id'] as String?,
      isCredit: json['isCredit'] as int?,
      isHealth: json['isHealth'] as int?,
      isPayTaxes: json['isPayTaxes'] as int?,
      isReal: json['isReal'] as int?,
      payTaxesPic: json['payTaxesPic'] as String?,
      realPic: json['realPic'] as String?,
      updateBy: json['updateBy'] as String?,
      updateTime: json['updateTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'createBy': createBy,
    'createTime': createTime,
    'creditPic': creditPic,
    'healthPic': healthPic,
    'id': id,
    'isCredit': isCredit,
    'isHealth': isHealth,
    'isPayTaxes': isPayTaxes,
    'isReal': isReal,
    'payTaxesPic': payTaxesPic,
    'realPic': realPic,
    'updateBy': updateBy,
    'updateTime': updateTime,
  };
}
