import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart' show TextEditingController, FocusNode;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FinalAuditReportAfterTelecastController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    initialAPI();
  }

  DropDownValue? selectedLocation, selectedChannel;
  var fromTC = TextEditingController(), toTC = TextEditingController();
  var dataTBList = <dynamic>[].obs;
  var locationList = <DropDownValue>[].obs, channelList = <DropDownValue>[].obs;
  var locationFN = FocusNode();

  initialAPI() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.FINAL_REPORT_AT_INITAIL,
      fun: (resp) {
        closeDialog();
        if (resp != null && resp is Map<String, dynamic> && resp['pageload'] != null && resp['pageload']['lstlocation'] != null) {
          locationList.clear();
          locationList.addAll((resp['pageload']['lstlocation'] as List<dynamic>)
              .map((e) => DropDownValue.fromJson({
                    "key": e['locationCode'].toString(),
                    "value": e["locationName"].toString(),
                  }))
              .toList());
        }
      },
      failed: (resp) {
        closeDialog();
      },
    );
  }

  getChannels(DropDownValue? val) {
    if (val == null) {
      LoadingDialog.showErrorDialog("Please select location.");
      return;
    }
    selectedLocation = val;
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.FINAL_REPORT_AT_GET_CHANNELS(selectedLocation!.key!),
      fun: (resp) {
        closeDialog();
        if (resp != null && resp is Map<String, dynamic> && resp['channels'] != null) {
          channelList.clear();
          channelList.addAll((resp['channels'] as List<dynamic>)
              .map((e) => DropDownValue.fromJson({
                    "key": e['channelCode'].toString(),
                    "value": e["channelName"].toString(),
                  }))
              .toList());
        }
      },
      failed: (resp) {
        closeDialog();
      },
    );
  }

  closeDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  handleReportTap() {
    if (selectedLocation == null || selectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location,channel.");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.FINAL_REPORT_AT_GET_DATA,
          fun: (resp) {
            closeDialog();
            if (resp != null && resp is Map<String, dynamic> && resp['genrateclick'] != null && (resp['genrateclick'] is List<dynamic>)) {
              dataTBList.clear();
              dataTBList.addAll((resp['genrateclick'] as List<dynamic>));
              if (dataTBList.isEmpty) {
                LoadingDialog.showErrorDialog("No data found.");
              }
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          },
          json: {
            "locationcode": selectedLocation?.key,
            "channelcode": selectedChannel?.key,
            "telecastdate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(fromTC.text)), //"2023-03-03"
            "todate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(toTC.text)),
            "flag": "S",
          });
    }
  }

  clearPage() {
    selectedLocation = null;
    selectedChannel = null;
    dataTBList.clear();
    locationList.refresh();
    channelList.refresh();

    locationFN.requestFocus();
  }
}
