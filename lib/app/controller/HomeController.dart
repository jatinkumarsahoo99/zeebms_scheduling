import 'dart:convert';
import 'dart:html' as html;

// import 'package:bms_programming/app/providers/ApiFactory.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../data/DrawerModel.dart';
import '../providers/Aes.dart';
import '../providers/ApiFactory.dart';
import '../routes/app_pages.dart';
import 'MainController.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  SubChild? selectChild;
  var selectChild1 = Rxn<SubChild>();
  List? buttons;

  bool isMoviePlannerPopupShown = false;

  @override
  void onInit() {
    getbuttondata();
    super.onInit();
  }

  getbuttondata() async {
    String value = await rootBundle.loadString('assets/json/buttons.json');
    buttons = json.decode(value);
    update(["buttons"]);
  }

  clearPage1() {
    String extractName = (html.window.location.href.split("?")[0]).split(ApiFactory.SPLIT_CLEAR_PAGE)[1];
    print("Extract name>>>>" + extractName);
    var uri = Uri.dataFromString(html.window.location.href); //converts string to a uri
    Map<String, String> params = uri.queryParameters;
    print("Params are>>>>" + params.toString());
    if (Routes.listRoutes.contains("/" + extractName)) {
      if (extractName == "frmDailyFPC") {
        html.window.location.reload();
      } else {
        String personalNo = Aes.encrypt(Get.find<MainController>().user?.personnelNo ?? "") ?? "";
        String loginCode = (Aes.encrypt(Get.find<MainController>().user?.logincode ?? "") ?? "");
        String formName = (Aes.encrypt(Get.find<MainController>().formName ?? "") ?? "");
        Get.offAndToNamed("/" + extractName, parameters: {"loginCode": loginCode, "personalNo": personalNo, "formName": formName});
      }
    }
  }
}
