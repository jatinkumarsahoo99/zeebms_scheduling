import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controller/HomeController.dart';

class SponserTypeMasterController extends GetxController {
  //TODO: Implement SponserTypeMasterController
  FocusNode sponserNameFocus = FocusNode();
  FocusNode sponserTypeFocus = FocusNode();
  FocusNode shortNameFocus = FocusNode();
  TextEditingController sponserName = TextEditingController(),
      shortName = TextEditingController(),
      premium = TextEditingController(text: "0");
  var selectedSponser = Rxn<DropDownValue>();
  String? sponsorTypeCode = "";
  @override
  void onInit() {
   /* sponserNameFocus.addListener(() {
      if ((!sponserNameFocus.hasFocus) && sponserName.text.isNotEmpty) {
        sponserName.text = sponserName.text.toUpperCase();
        getData();
      }
    });*/
    sponserNameFocus = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          if (sponserName.text.isNotEmpty) {
            sponserName.text = sponserName.text.toUpperCase();
            getData();
            return KeyEventResult.ignored;
          }
        }
        return KeyEventResult.ignored;
      },
    );
    super.onInit();
  }

  getData() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SponserTypeMasterGetRecord("", sponserName.text),
        fun: (data) {
          closeDialogIfOpen();
          if (data is Map &&
              data.containsKey("sponsorType") &&
              (data["sponsorType"] as List).isNotEmpty) {
            shortName.text = data["sponsorType"][0]["sponsorTypeShortName"];
            premium.text = data["sponsorType"][0]["sponsorPremium"].toString();
            if (data["sponsorType"][0]["sponsorType"]
                    .toString()
                    .toLowerCase() ==
                "m") {
              selectedSponser.value =
                  DropDownValue(key: "M", value: "Multiple");
            }
            if (data["sponsorType"][0]["sponsorType"]
                    .toString()
                    .toLowerCase() ==
                "s") {
              selectedSponser.value = DropDownValue(key: "S", value: "Single");
            }
            sponsorTypeCode = data["sponsorType"][0]["sponsorTypeCode"];
            print(">>>>>>>>>>sponsorTypeCode"+sponsorTypeCode.toString());
          }
        });
  }
  validateSave(){
    if(sponsorTypeCode  != ""){
      LoadingDialog.recordExists(
          "Record Already exist!\nDo you want to modify it?", () {
        saveData();
        // update(['top']);
      });
    }else{
      saveData();
    }
  }

  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
  saveData() {
    if(sponserName.text.trim() == ""){
      LoadingDialog.showErrorDialog("Sponsor cannot be empty.");
    }else if(shortName.text.trim() == ""){
      LoadingDialog.showErrorDialog("Short Name cannot be empty.");
    }else if(selectedSponser.value == null){
      LoadingDialog.showErrorDialog("Sponsor Type cannot be empty.");
    }
    else{
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.SponserTypeMasterSaveRecord,
          json: {
            "sponsorTypeCode": sponsorTypeCode.toString(),
            "sponsorTypeName": sponserName.text,
            "sponsorTypeShortName": shortName.text,
            "sponsorPremium": premium.text,
            "sponsorType": selectedSponser.value?.value,
            "modifiedBy": Get.find<MainController>().user?.logincode
          },
          fun: (data) {
            closeDialogIfOpen();
            if (data is Map && data.containsKey("sponsorType")) {
              Get.delete<SponserTypeMasterController>();
              Get.find<HomeController>().clearPage1();
              LoadingDialog.callDataSaved(msg: data["sponsorType"]);
            }
            if (data is String) {
              LoadingDialog.callErrorMessage1(msg: data);
            }
          });
    }

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
