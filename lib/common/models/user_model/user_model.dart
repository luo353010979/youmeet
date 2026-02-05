import 'user_message.dart';

class UserModel {
  String? token;
  UserMessage? userMessage;

  UserModel({this.token, this.userMessage});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    token: json['token'] as String?,
    userMessage: json['userMessage'] == null
        ? null
        : UserMessage.fromJson(json['userMessage'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'userMessage': userMessage?.toJson(),
  };
}
