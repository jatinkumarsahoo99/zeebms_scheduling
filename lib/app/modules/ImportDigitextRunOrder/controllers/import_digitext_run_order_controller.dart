import 'package:get/get.dart';

class ImportDigitextRunOrderController extends GetxController {
  //TODO: Implement ImportDigitextRunOrderController
  List<String> radiofilters = [
    "Missing Chart",
    "New Brands",
    "NewClocks",
    "Missing Links",
    "My Data"
  ];
  String selectedradiofilter = "Missing Chart";

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
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
