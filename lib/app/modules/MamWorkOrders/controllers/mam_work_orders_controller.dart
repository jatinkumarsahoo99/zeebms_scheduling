import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MamWorkOrdersController extends GetxController {
  //TODO: Implement MamWorkOrdersController
  List<String> mainTabs = ["Release WO Non FPC", "WO As Per Daily FPC", "WO Re-push", "Cancel WO", "WO History"];
  var selectedTab = "Release WO Non FPC".obs;
  PageController pageController = PageController();
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
