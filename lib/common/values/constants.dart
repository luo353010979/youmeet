/// 常量
class Constants {
  // wp 服务器
  static const wpApiBaseUrl = 'http://114.66.37.86:8180';
  static const wkImAddr = '114.66.37.86:5100';
  static const imgDomain = 'http://t.pic.mooneyu.com/';

  // 本地存储key
  static const storageLanguageCode = 'language_code';

  static const storageAlreadyOpen = 'already_open'; // 首次打开

  // AES
  static const aesKey = 'aH5aH5bG0dC6aA3oN0cK4aU5jU6aK2lN';
  static const aesIV = 'hK6eB4aE1aF3gH5q';

  static const storageToken = 'token'; // 登录成功后 token
  static const storageProfile = 'profile'; // 用户资料缓存
  static const paramUser = 'param_user'; // 用户详情

  static const paramFeed = 'param_feed'; // 动态详情

  static const editParams = "edit_params"; // 编辑参数
  static const editNickname = 0; // 编辑昵称
  static const editProfile = 1; // 编辑个人简介
  static const editHeight = 2; // 编辑身高
  static const editWeight = 3; // 编辑体重

  static const avatar = "avatar"; // 头像
  static const realPic = "real_pic"; // 背景图
}
