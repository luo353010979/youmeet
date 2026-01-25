import 'package:flutter/material.dart';
import 'package:youmeet/common/index.dart';

class ScaffoldWidget extends StatelessWidget {
  const ScaffoldWidget({
    super.key,
    required this.child,
    this.appBar,
    this.useSafeArea = true,
  });

  final Widget child;
  final PreferredSizeWidget? appBar;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetsImages.imgBackgroundDefautPng),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: appBar,
        body: useSafeArea ? SafeArea(child: child) : child,
      ),
    );
  }
}
