import 'package:get/get.dart';

class AboutUsController extends GetxController {
  AboutUsController();

  final list = <String>[].obs;

  _initData() {
    loadData(1);
    update(["about_us"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  void loadData(int size) {
    final s = List.generate(size, (index) {
      return "数据 ${list.length + index}";
    });
    list.addAll(s);
  }

  void add() {
    print("插入");
    list.insert(0, "插入新数据${list.length + 1}");
  }
}
