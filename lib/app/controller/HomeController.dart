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
  List? tranmissionButtons;
  List? asurunImportButtoons;

  bool isMoviePlannerPopupShown = false;

  @override
  void onInit() {
    getbuttondata();
    getTransmissionLog();
    super.onInit();
  }

  getbuttondata() async {
    String value = await rootBundle.loadString('assets/json/buttons.json');
    buttons = json.decode(value);
    update(["buttons"]);
  }

  getTransmissionLog() async {
    String value = await rootBundle.loadString('assets/json/transmission_buttons.json');
    tranmissionButtons = json.decode(value)["transmissionLog"];
    asurunImportButtoons = json.decode(value)["assrunImport"];
    update(["transButtons"]);
  }

  clearPage1() {
    try {
      print(html.window.location.href);
      String extractName = (html.window.location.href.split("?")[0]).split(ApiFactory.SPLIT_CLEAR_PAGE)[1];
      print("Extract name>>>>" + extractName);
      var uri = Uri.dataFromString(html.window.location.href); //converts string to a uri
      Map<String, String> params = uri.queryParameters;
      print("Params are>>>>" + params.toString());
      if (RoutesList.listRoutes.contains("/" + extractName)) {
        if (extractName == "frmDailyFPC") {
          html.window.location.reload();
        } else {
          String personalNo = Aes.encrypt(Get.find<MainController>().user?.personnelNo ?? "") ?? "";
          String loginCode = (Aes.encrypt(Get.find<MainController>().user?.logincode ?? "") ?? "");
          String formName = (Aes.encrypt(Get.find<MainController>().formName) ?? "");
          Get.offAndToNamed("/" + extractName, parameters: {"loginCode": loginCode, "personalNo": personalNo, "formName": formName});
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
