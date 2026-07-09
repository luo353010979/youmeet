import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class SelectCountryController extends GetxController {
  /// 完整国家列表（原始数据）
  List<CountryModel> allCountryList = [];

  /// 过滤后展示的国家列表
  List<CountryModel> countryList = [];

  /// 当前搜索关键字
  String keyword = "";

  /// 是否中文环境
  bool get isZh => ConfigService.to.locale.languageCode == 'zh';

  /// 根据当前语言返回国家名称
  String countryName(CountryModel country) {
    if (isZh) {
      return country.chinese ?? country.english ?? "";
    }
    return country.english ?? country.chinese ?? "";
  }

  @override
  void onReady() {
    super.onReady();
    getCountryList();
  }

  void getCountryList() async {
    try {
      Loading.show();
      BaseResponse<List<CountryModel>> countries =
          await SystemApi.requestCountryList();
      allCountryList = countries.result ?? [];
      _applyFilter();
      logger.d("获取国家列表成功: ${allCountryList.length} 个国家");
      update(["select_country"]);
    } catch (e) {
      logger.d("获取国家列表失败: $e");
    } finally {
      Loading.dismiss();
    }
  }

  /// 搜索：国家名称（中/英）或区号
  void onSearch(String value) {
    keyword = value.trim();
    _applyFilter();
    update(["select_country"]);
  }

  void _applyFilter() {
    if (keyword.isEmpty) {
      countryList = List.of(allCountryList);
      return;
    }
    final lower = keyword.toLowerCase();
    countryList = allCountryList.where((country) {
      final chinese = (country.chinese ?? "").toLowerCase();
      final english = (country.english ?? "").toLowerCase();
      final phone = (country.phone ?? "").toLowerCase();
      final shortEn = (country.shortEn ?? "").toLowerCase();
      return chinese.contains(lower) ||
          english.contains(lower) ||
          phone.contains(lower) ||
          shortEn.contains(lower);
    }).toList();
  }
}
