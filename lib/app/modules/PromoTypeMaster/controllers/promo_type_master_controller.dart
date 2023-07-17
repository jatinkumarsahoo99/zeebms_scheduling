import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PromoTypeMasterController extends GetxController {
  //TODO: Implement PromoTypeMasterController

  TextEditingController promTypeNameCtrl = TextEditingController(), sapCategory = TextEditingController();
  FocusNode promoFocusNode = FocusNode();
  var trailPromo = RxBool(false);
  var channelSpec = RxBool(false);
  String? programTypeCode;
  @override
  void onInit() {
    promoFocusNode.addListener(() {
      if ((!promoFocusNode.hasFocus) && promTypeNameCtrl.text.isNotEmpty) {
        getData();
      }
    });
    super.onInit();
  }

  getData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.PROMO_TYPE_MASTER_GET_RECORD(promTypeNameCtrl.text, ""),
        fun: (data) {
          if (data is Map && data.containsKey("promomaster") && (data["promomaster"] as List).isNotEmpty) {
            promTypeNameCtrl.text = data["promomaster"][0]["promoTypeName"];
            sapCategory.text = data["promomaster"][0]["sapCategory"];
            // spotPostionName.text = data["retrieveRecord"][0]["spotPositionTypeName"];
            // spotShortName.text = data["retrieveRecord"][0]["spotPositionShortName"].toString();
            // positionPremium.text = data["retrieveRecord"][0]["spotPositionPremium"].toString();
            // logPosition.text = data["retrieveRecord"][0]["spotPositionInLog"].toString();

            if (data["promomaster"][0]["channelSpecific"].toString().toLowerCase() == "y") {
              channelSpec.value = true;
            } else {
              channelSpec.value = false;
            }
            if (data["retrieveRecord"][0]["istraiPromo"] == 1) {
              trailPromo.value = true;
            } else {
              trailPromo.value = false;
            }
            // selectedSpotInLog.value = spots
            //     .firstWhereOrNull((element) => element.key?.toLowerCase() == data["retrieveRecord"][0]["spotComesInLog"].toString().toLowerCase());
            // // if (data["sponsorType"][0]["spotComesInLog"].toString().toLowerCase() == "s") {
            // //   selectedSpotInLog.value = DropDownValue(key: "S", value: "Single");
            // // }
            // // if (data["sponsorType"][0]["sponsorType"].toString().toLowerCase() == "m") {
            // //   selectedSponser.value = DropDownValue(key: "M", value: "Multiple");
            // // }
            // // if (data["sponsorType"][0]["sponsorType"].toString().toLowerCase() == "s") {
            // //   selectedSponser.value = DropDownValue(key: "S", value: "Single");
            // // }
            // spotPositionTypeCode = data["retrieveRecord"][0]["spotPositionTypeCode"];
          }
        });
  }

  saveData() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.PROMO_TYPE_MASTER_SAVE,
        json: {
          "promoTypeCode": programTypeCode,
          "promoTypeName": promTypeNameCtrl.text,
          "modifiedBy": Get.find<MainController>().user?.logincode,
          "channelSpecific": channelSpec.value ? "Y" : "N",
          "istraiPromo": trailPromo.value ? 1 : 0,
          "sapCategory": sapCategory.text
        },
        fun: (data) {
          if (data is Map && data.containsKey("promomaster")) {
            LoadingDialog.callDataSaved(msg: data["promomaster"]);
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
