import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class SelectCountryController extends GetxController {
  List<CountryModel> countryList = [];

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
      countryList = countries.result ?? [];
      logger.d("获取国家列表成功: ${countryList.length} 个国家");
      update(["select_country"]);
    } catch (e) {
      logger.d("获取国家列表失败: $e");
    }finally {
      Loading.dismiss();
    }
  }
}
