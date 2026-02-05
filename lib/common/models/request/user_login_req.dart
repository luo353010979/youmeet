class UserLoginReq {
  String? account;
  String? password;

  UserLoginReq({this.account, this.password});

  factory UserLoginReq.fromJson(Map<String, dynamic> json) => UserLoginReq(
    account: json['account'] as String?,
    password: json['password'] as String?,
  );

  Map<String, dynamic> toJson() => {'account': account, 'password': password};
}
