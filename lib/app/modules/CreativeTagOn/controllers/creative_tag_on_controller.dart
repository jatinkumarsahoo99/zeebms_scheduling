import 'package:get/get.dart';

import '../../../../widgets/cutom_dropdown.dart';

class CreativeTagOnController extends GetxController {
  //TODO: Implement CreativeTagOnController


  final count = 0.obs;
  bool isEnable = true;

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

  void increment() => count.value++;
}
