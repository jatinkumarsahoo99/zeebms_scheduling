import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/HomeController.dart';

class SpotPositionTypeMasterController extends GetxController {
  //TODO: Implement SpotPositionTypeMasterController

  TextEditingController spotPostionName = TextEditingController(),
      spotShortName = TextEditingController(),
      logPosition = TextEditingController(text: "0"),
      positionPremium = TextEditingController(text: "0");
  var selectedSpotInLog = Rxn<DropDownValue>();
  var breakNo = RxBool(false);
  var spots = RxList<DropDownValue>();
  var positionNo = RxBool(false);
  FocusNode positionNameFocus = FocusNode();
  FocusNode typeShortNameFocus = FocusNode();
  String? spotPositionTypeCode = "";

  @override
  void onInit() {
    getInitData();
    positionNameFocus.addListener(() {
      if ((!positionNameFocus.hasFocus) && spotPostionName.text.isNotEmpty) {
        spotPostionName.text = spotPostionName.text.toUpperCase();
        getData();
      }
    });

    typeShortNameFocus.addListener(() {
      if(spotShortName.text.isNotEmpty){
        spotShortName.text = spotShortName.text.toUpperCase();
      }
    });
    super.onInit();
  }

  getInitData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SpotPositionTypeInit,
        fun: (data) {
          if (data is Map && data.containsKey("setSpotPriority")) {
            for (var element in data["setSpotPriority"]) {
              spots.add(DropDownValue(
                  key: element["lookupCode"], value: element["lookupName"]));
            }
          }
        });
  }

  getData() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SpotPositionTypeGetRecord("", spotPostionName.text),
        fun: (data) {
          closeDialogIfOpen();
          if (data is Map &&
              data.containsKey("retrieveRecord") &&
              (data["retrieveRecord"] as List).isNotEmpty) {
            spotPostionName.text =
                data["retrieveRecord"][0]["spotPositionTypeName"];
            spotShortName.text =
                data["retrieveRecord"][0]["spotPositionShortName"].toString();
            positionPremium.text =
                data["retrieveRecord"][0]["spotPositionPremium"].toString();
            logPosition.text =
                data["retrieveRecord"][0]["spotPositionInLog"].toString();

            if (data["retrieveRecord"][0]["positionApplies"]
                    .toString()
                    .toLowerCase() ==
                "y") {
              positionNo.value = true;
            } else {
              positionNo.value = false;
            }
            if (data["retrieveRecord"][0]["breakNumberApplies"]
                    .toString()
                    .toLowerCase() ==
                "y") {
              breakNo.value = true;
            } else {
              breakNo.value = false;
            }
            selectedSpotInLog.value = spots.firstWhereOrNull((element) =>
                element.key?.toLowerCase() ==
                data["retrieveRecord"][0]["spotComesInLog"]
                    .toString()
                    .toLowerCase());
            // if (data["sponsorType"][0]["spotComesInLog"].toString().toLowerCase() == "s") {
            //   selectedSpotInLog.value = DropDownValue(key: "S", value: "Single");
            // }
            // if (data["sponsorType"][0]["sponsorType"].toString().toLowerCase() == "m") {
            //   selectedSponser.value = DropDownValue(key: "M", value: "Multiple");
            // }
            // if (data["sponsorType"][0]["sponsorType"].toString().toLowerCase() == "s") {
            //   selectedSponser.value = DropDownValue(key: "S", value: "Single");
            // }
            spotPositionTypeCode =
                data["retrieveRecord"][0]["spotPositionTypeCode"];
          }
        });
  }

  validateSave(){
    if(spotPositionTypeCode  != ""){
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
    if(spotPostionName.text == ""){
      LoadingDialog.showErrorDialog("Spot Type Position Name cannot be empty.");
    }else if(spotShortName.text == ""){
      LoadingDialog.showErrorDialog("Spot Type Short Name cannot be empty.");
    }else if(selectedSpotInLog.value == null){
      LoadingDialog.showErrorDialog("Please Select Spot Short Name.");
    }else{
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.SpotPositionTypeSaveRecord,
          json: {
            "spotPositionTypeCode": spotPositionTypeCode,
            "spotPositionTypeName": spotPostionName.text,
            "spotPositionShortName": spotShortName.text,
            "spotPositionInLog": logPosition.text,
            "spotComesInLog": selectedSpotInLog.value?.key,
            "breakNumberApplies": breakNo.value ? "Y" : "N",
            "positionApplies": positionNo.value ? "Y" : "N",
            "modifiedBy": Get.find<MainController>().user?.logincode,
            "spotPositionPremium": positionPremium.text
          },
          fun: (data) {
            closeDialogIfOpen();
            if (data is Map && data.containsKey("saveRecord")) {
              Get.delete<SpotPositionTypeMasterController>();
              Get.find<HomeController>().clearPage1();
              LoadingDialog.callDataSaved(msg: data["saveRecord"]);
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
