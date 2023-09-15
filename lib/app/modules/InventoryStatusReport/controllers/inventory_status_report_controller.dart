import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/HomeController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';
import '../../SalesAuditNotTelecastReport/ChannelListModel.dart';
import '../model/inventory_status_report_on_load_model.dart';

class InventoryStatusReportController extends GetxController {
  List<PermissionModel>? formPermissions;
  var fromDateTC = TextEditingController(), toDateTC = TextEditingController();
  var dataTableList = [].obs;
  var channelAllSelected = false.obs;
  DropDownValue? selectedLocation, selectedChannel;
  late FocusNode locationFN;
  var selectedRadio = "".obs;
  Rxn<InventoryStatusReportLoadModel?> onLoadModel =
      Rxn<InventoryStatusReportLoadModel?>();

  PlutoGridStateManager? stateManager;
  UserDataSettings? userDataSettings;
  ScrollController scrollController = new ScrollController();
  FocusScopeNode focusNodeList = FocusScopeNode();
  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(
        Routes.INVENTORY_STATUS_REPORT.replaceAll("/", ""));

    locationFN =  FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
    );

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getInitialData();
    fetchUserSetting1();
  }

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
    dataTableList.refresh();
  }

  formHandler(btn) {
    if (btn == "Clear") {
      clearPage();
    } else if (btn == "Exit") {
      Get.find<HomeController>().postUserGridSetting2(listStateManager: [
        {"stateManager": stateManager},
      ]);
    }
  }

  hanldeChangedOnAllChannel(bool? val) {
    channelAllSelected.value = val ?? false;
    var tempChannelList = onLoadModel.value?.info?.channels?.map(
      (e) {
        e.isSelected = val ?? false;
        return e;
      },
    ).toList();
    onLoadModel.value?.info?.channels = tempChannelList ?? [];
    onLoadModel.refresh();
  }

  clearPage() {
    // try {
    //   selectedLocation = onLoadModel.value?.info?.locations
    //       ?.firstWhere((element) => element.value == "ASIA");
    // } catch (e) {}
    selectedRadio.value = "";
    channelAllSelected.value = false;
    var tempChannelList = onLoadModel.value?.info?.channels?.map(
      (e) {
        e.isSelected = false;
        return e;
      },
    ).toList();

    onLoadModel.value?.info?.channels = tempChannelList ?? [];
    fromDateTC.clear();
    toDateTC.clear();
    dataTableList.clear();
    onLoadModel.refresh();
    locationFN.requestFocus();
  }

  void getInitialData() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.INVENTORY_STATUS_REPORT_ON_LOAD,
      fun: (resp) {
        closeDialogIfOpen();
        if (resp != null && resp is Map<String, dynamic>) {
          onLoadModel.value = InventoryStatusReportLoadModel.fromJson(resp);
          // try {
          //   selectedLocation = onLoadModel.value?.info?.locations
          //       ?.firstWhere((element) => element.value == "ASIA");
          // } catch (e) {}
          // onLoadModel.refresh();
        } else {
          LoadingDialog.showErrorDialog(resp.toString());
        }
      },
      failed: (resp) {
        closeDialogIfOpen();
        LoadingDialog.showErrorDialog(resp.toString());
      },
    );
  }

  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  void generateData() {
    if (selectedLocation == null) {
      LoadingDialog.showErrorDialog("Please select Location");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.INVENTORY_STATUS_REPORT_GENERATE,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['generate'] != null) {
            if ((resp['generate']['lstdetails'] as List<dynamic>).isNotEmpty) {
              dataTableList.clear();
              dataTableList.addAll((resp['generate']['lstdetails']));
            }
            if ((resp['generate']['lstsummary'] as List<dynamic>).isNotEmpty) {
              dataTableList.clear();
              dataTableList.addAll((resp['generate']['lstsummary']));
            }

            if ((resp['generate']['lstold'] as List<dynamic>).isNotEmpty) {
              dataTableList.clear();
              dataTableList.addAll((resp['generate']['lstold']));
            }
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        json: {
          "lstchannelCheckbox": onLoadModel.value?.info?.channels
              ?.map((e) => e.toJson())
              .toList(),
          "locationcode": selectedLocation?.key,
          "channelCode": "",
          "fromdate": DateFormat("yyyy-MM-dd")
              .format(DateFormat("dd-MM-yyyy").parse(fromDateTC.text)),
          "todate": DateFormat("yyyy-MM-dd")
              .format(DateFormat("dd-MM-yyyy").parse(toDateTC.text)),
          "chk_rdoreport": selectedRadio.value == "Detail (KAM-NON CAM)",
          "chk_rdosummary": selectedRadio.value == "Summary (KAM-NON KAM)",
          "chk_rdooldformat": selectedRadio.value == "Old Format",
        },
      );
    }
  }
}
