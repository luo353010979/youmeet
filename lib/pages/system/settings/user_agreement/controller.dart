import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class UserAgreementController extends GetxController {
  UserAgreementController();

  late WebViewController controller;
  bool isLoading = true;

  Future<String> _loadHtmlFromAssets() async {
    final htmlContent = await rootBundle.loadString('assets/html/user_agreement.html');
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/user_agreement.html');
    await file.writeAsString(htmlContent);
    return file.path;
  }

  _initData() {
    update(["user_agreement"]);
  }

  void onTap() {}

  @override
  void onReady() {
    super.onReady();
    _initData();
    _loadHtmlFromAssets().then((filePath) {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {
              isLoading = true;
              update(["user_agreement"]);
            },
            onPageFinished: (String url) {
              isLoading = false;
              update(["user_agreement"]);
            },
            onHttpError: (HttpResponseError error) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadFile(filePath);
      // 初始加载也显示loading
      isLoading = true;
      update(["user_agreement"]);
    });
  }
}
