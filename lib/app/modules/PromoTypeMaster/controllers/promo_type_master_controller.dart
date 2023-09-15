import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/HomeController.dart';
import '../../CommonSearch/views/common_search_view.dart';

class PromoTypeMasterController extends GetxController {
  FocusNode categoryFN = FocusNode();

  TextEditingController promTypeNameCtrl = TextEditingController(),
      sapCategory = TextEditingController();
  FocusNode promoFocusNode = FocusNode();
  var trailPromo = RxBool(false);
  var channelSpec = RxBool(false);
  String? programTypeCode;
  var promoCategories = <DropDownValue>[].obs;
  DropDownValue? selectedCategory;
  var isActive = false.obs;
  @override
  void onInit() {
    promoFocusNode.addListener(() {
      if ((!promoFocusNode.hasFocus) && promTypeNameCtrl.text.isNotEmpty) {
        promTypeNameCtrl.text = promTypeNameCtrl.text.toUpperCase();
        getData();
      }
    });
    super.onInit();
  }

  getData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.PROMO_TYPE_MASTER_GET_RECORD(promTypeNameCtrl.text, ""),
        fun: (data) {
          if (data != null &&
              data['promomaster'] != null &&
              (data['promomaster'] as List<dynamic>).isNotEmpty) {
            print(data["promomaster"][0]["promoTypeCode"]);
            if (data["promomaster"][0]["promoTypeCode"] != null) {
              programTypeCode = data["promomaster"][0]["promoTypeCode"];
            }
            promTypeNameCtrl.text = data["promomaster"][0]["promoTypeName"];
            sapCategory.text = data["promomaster"][0]["sapCategory"];
            if (data["promomaster"][0]["channelSpecific"]
                    .toString()
                    .toLowerCase() ==
                "y") {
              channelSpec.value = true;
            } else {
              channelSpec.value = false;
            }
            if (data["promomaster"][0]["istraiPromo"] == 1) {
              trailPromo.value = true;
            } else {
              trailPromo.value = false;
            }
          }
        });
  }

  void validateSaveRecord() {
    if (selectedCategory == null) {
      LoadingDialog.showErrorDialog("Please select promo category name.");
    } else if (promTypeNameCtrl.text.trim().isEmpty) {
      LoadingDialog.showErrorDialog("Please enter promo type name.");
    } else if (sapCategory.text.trim().isEmpty) {
      LoadingDialog.showErrorDialog("Please enter SAP category.");
    } else {
      if (programTypeCode!.isEmpty) {
        saveData();
      } else {
        LoadingDialog.call();
        Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.PROMO_TYPE_MASTER_VALIDATE_SAVE_RECORD,
          json: {"promoTypeCode": programTypeCode},
          fun: (resp) {
            Get.back();
            if (resp != null && resp['result'].toString().contains('Record')) {
              LoadingDialog.recordExists(
                resp['result'].toString(),
                () {
                  saveData();
                },
              );
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          },
        );
      }
    }
  }

  saveData() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.PROMO_TYPE_MASTER_SAVE,
      json: {
        "promoTypeCode": programTypeCode ?? "",
        "promoTypeName": promTypeNameCtrl.text,
        "modifiedBy": Get.find<MainController>().user?.logincode,
        "channelSpecific": channelSpec.value ? "Y" : "N",
        "istraiPromo": trailPromo.value ? 1 : 0,
        "sapCategory": sapCategory.text,
        "CategoryCode": selectedCategory?.key ?? "",
        "IsActive": isActive.value,
      },
      fun: (data) {
        Get.back();
        if (data is Map && data.containsKey("promomaster")) {
          LoadingDialog.callDataSaved(msg: data["promomaster"]);
        } else if (data is String) {
          LoadingDialog.callErrorMessage1(msg: data);
        }
      },
    );
  }

  btnHandler(btnName) {
    switch (btnName) {
      case "Delete":
        null;
        break;
      case "Clear":
        Get.delete<PromoTypeMasterController>();
        Get.find<HomeController>().clearPage1();
        break;
      case "Save":
        validateSaveRecord();
        break;
      case "Search":
        Get.to(const SearchPage(
          key: Key("Promo Type Master"),
          screenName: "Promo Type Master",
          appBarName: "Promo Type Master",
          strViewName: "vTesting",
          isAppBarReq: true,
        ));
        break;
      default:
    }
  }

  @override
  void onReady() {
    super.onReady();
    getCategory();
  }

  getCategory() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.PROMO_TYPE_MASTER_GET_CATEGORY,
      fun: (resp) {
        Get.back();
        if (resp != null && resp['promoCategory'] != null) {
          promoCategories.clear();
          for (var element in resp['promoCategory']) {
            if (element['promoCategoryCode'] == '--Select--') {
              continue;
            }
            promoCategories.add(DropDownValue(
                key: element['promoCategoryCode'].toString(),
                value: element['promoCategoryName'].toString()));
          }
          promoCategories.refresh();
        }
      },
      failed: (resp) {
        Get.back();
      },
    );
  }
}
