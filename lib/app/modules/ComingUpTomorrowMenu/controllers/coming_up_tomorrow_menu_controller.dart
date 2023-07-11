import 'package:get/get.dart';

import '../../../../widgets/cutom_dropdown.dart';

class ComingUpTomorrowMenuController extends GetxController {
  //TODO: Implement ComingUpTomorrowMenuController
  bool isEnable = true;

  final count = 0.obs;
  var clientDetails = RxList<DropDownValue>();
  DropDownValue? selectedClientDetails;
  var controllsEnabled = true.obs;
  var selectedRadio = "".obs;
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

  formHandler(String string) {

  }
  void increment() => count.value++;
}
