import 'dart:developer';

import 'package:get/get.dart';

import '../../../../widgets/cutom_dropdown.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../providers/ApiFactory.dart';

class CommercialMasterController extends GetxController {
  //TODO: Implement CommercialMasterController

  final count = 0.obs;
  var language = RxList<DropDownValue>();
  DropDownValue? selectedLanguage;


  @override
  void onInit() {
    getAllDropDownList();
    super.onInit();
  }
  getAllDropDownList(){
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMMERCIAL_MASTER_ALLDROPDOWN,
        fun: (Map map) {
               log(">>>"+map.toString());
        });
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

  formHandler(String string) {}
}
