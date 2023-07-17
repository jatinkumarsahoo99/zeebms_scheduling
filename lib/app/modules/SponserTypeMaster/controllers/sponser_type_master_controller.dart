import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SponserTypeMasterController extends GetxController {
  //TODO: Implement SponserTypeMasterController
  FocusNode sponserNameFocus = FocusNode();
  TextEditingController sponserName = TextEditingController(), shortName = TextEditingController(), premium = TextEditingController();
  var selectedSponser = Rxn<DropDownValue>();
  String? sponsorTypeCode;
  @override
  void onInit() {
    sponserNameFocus.addListener(() {
      if ((!sponserNameFocus.hasFocus) && sponserName.text.isNotEmpty) {
        getData();
      }
    });
    super.onInit();
  }

  getData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SponserTypeMasterGetRecord("", sponserName.text),
        fun: (data) {
          if (data is Map && data.containsKey("sponsorType") && (data["sponsorType"] as List).isNotEmpty) {
            shortName.text = data["sponsorType"][0]["sponsorTypeShortName"];
            premium.text = data["sponsorType"][0]["sponsorPremium"].toString();
            if (data["sponsorType"][0]["sponsorType"].toString().toLowerCase() == "m") {
              selectedSponser.value = DropDownValue(key: "M", value: "Multiple");
            }
            if (data["sponsorType"][0]["sponsorType"].toString().toLowerCase() == "s") {
              selectedSponser.value = DropDownValue(key: "S", value: "Single");
            }
            sponsorTypeCode = data["sponsorType"][0]["sponsorTypeCode"];
          }
        });
  }

  saveData() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.SponserTypeMasterSaveRecord,
        json: {
          "sponsorTypeCode": sponsorTypeCode.toString(),
          "sponsorTypeName": sponserName.text,
          "sponsorTypeShortName": shortName.text,
          "sponsorPremium": premium.text,
          "sponsorType": selectedSponser.value?.key,
          "modifiedBy": Get.find<MainController>().user?.logincode
        },
        fun: (data) {
          if (data is Map && data.containsKey("sponsorType")) {
            LoadingDialog.callDataSaved(msg: data["sponsorType"]);
          }
          if (data is String) {
            LoadingDialog.callErrorMessage1(msg: data);
          }
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
}
