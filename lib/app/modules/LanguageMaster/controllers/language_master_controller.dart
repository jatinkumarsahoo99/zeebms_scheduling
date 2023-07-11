import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';
import '../../CommonSearch/views/common_search_view.dart';

class LanguageMasterController extends GetxController {
  List<PermissionModel>? formPermissions;
  var textEditingTC = TextEditingController();
  var langaugeFN = FocusNode();
  String? code;

  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(Routes.LANGUAGE_MASTER.replaceAll("/", ""));
    super.onInit();
  }

  clearPage() {
    textEditingTC.clear();
    code = null;
    langaugeFN.requestFocus();
  }

  @override
  void onReady() {
    super.onReady();
    langaugeFN.addListener(() {
      if (!langaugeFN.hasFocus) {
        tapeIDLeave();
      }
    });
  }

  tapeIDLeave() {
    if (textEditingTC.text.trim().isNotEmpty) {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.LANGAUGE_MASTER_LANGAUGE_NAME_LEAVE,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is Map<String, dynamic> && resp['languagemaster'] != null && resp['languagemaster'] is List<dynamic>) {
            if ((resp['languagemaster'] as List<dynamic>).isNotEmpty) {
              code = resp['languagemaster'][0]['languageCode'];
              textEditingTC.text = resp['languagemaster'][0]['languageName'];
            }
          }
        },
        json: {"languageCode": "", "languageName": textEditingTC.text},
      );
    }
  }

  saveRecord() {
    if (textEditingTC.text.trim().isNotEmpty) {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.LANGAUGE_MASTER_SAVE_RECORD,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['languagemaster'] != null &&
              resp['languagemaster'].toString().contains("successfully.")) {
            LoadingDialog.callDataSaved(
              msg: resp['languagemaster'].toString(),
              callback: () {
                clearPage();
              },
            );
          } else {
            if (resp.toString().contains("languagemaster")) {
              LoadingDialog.showErrorDialog(resp['languagemaster'].toString());
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          }
        },
        json: {
          "languageCode": code ?? "",
          "languageName": textEditingTC.text,
        },
      );
    } else {
      LoadingDialog.showErrorDialog("Please enter Langauge Name.", callback: () {
        langaugeFN.requestFocus();
      });
    }
  }

  @override
  void onClose() {
    textEditingTC.dispose();
    langaugeFN.removeListener(() {});
    super.onClose();
  }

  formHandler(btn) {
    if (btn == "Clear") {
      clearPage();
    } else if (btn == "Search") {
      Get.to(
        SearchPage(
          key: Key("Langauge Master"),
          screenName: "Langauge Master",
          appBarName: "Langauge Master",
          strViewName: "vbrandmaster",
          isAppBarReq: true,
        ),
      );
    } else if (btn == "Save") {
      if (code == null) {
        saveRecord();
      } else {
        LoadingDialog.recordExists("Record Already exist!\nDo you want to modify it?", () {
          saveRecord();
        });
      }
    }
  }

  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
