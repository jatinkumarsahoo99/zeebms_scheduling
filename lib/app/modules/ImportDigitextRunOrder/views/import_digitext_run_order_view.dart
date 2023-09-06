import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/app/providers/Utils.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:bms_scheduling/widgets/radio_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controller/HomeController.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/user_data_settings_model.dart';
import '../controllers/import_digitext_run_order_controller.dart';

class ImportDigitextRunOrderView
    extends GetView<ImportDigitextRunOrderController> {
  const ImportDigitextRunOrderView({Key? key}) : super(key: key);

  getPageData(int index) {
    switch (index) {
      case 0:
        return (controller.digitexRunOrderData?.missingClients
                ?.map((e) => e.toJson())
                .toList() ??
            []);
      case 1:
        return (controller.digitexRunOrderData?.newBrands ?? []);
      case 2:
        return (controller.digitexRunOrderData?.newClocks ?? []);
      case 3:
        return (controller.digitexRunOrderData?.missingAgencies
                ?.map((e) => e.toJson())
                .toList() ??
            []);
      case 4:
        return (controller.digitexRunOrderData?.missingLinks
                ?.map((e) => e.toJson())
                .toList() ??
            []);
      case 5:
        return (controller.digitexRunOrderData?.myData
                ?.map((e) => e.toJson())
                .toList() ??
            []);
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Section with Controls
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    spacing: 10,
                    children: [
                      Obx(
                        () => DropDownField.formDropDown1WidthMap(
                            controller.locations.value, (value) {
                          controller.selectedLocation = value;
                          controller.getChannel(value.key);
                        }, "Location", 0.18),
                      ),
                      Obx(
                        () => DropDownField.formDropDown1WidthMap(
                            controller.channels.value, (value) {
                          controller.selectedChannel = value;
                        }, "Channel", 0.18),
                      ),
                      DateWithThreeTextField(
                          title: "Schedule Date.",
                          widthRation: 0.12,
                          mainTextController: controller.scheduleDate),
                      FormButtonWrapper(
                        btnText: "Load",
                        iconDataM: Icons.upload_file_rounded,
                        callback: () {
                          controller.pickFile();
                        },
                      ),
                      InputFields.formField1(
                          hintTxt: "File",
                          isEnable: false,
                          width: 0.24,
                          controller: controller.fileController),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Card(
          //   clipBehavior: Clip.hardEdge,
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.vertical(
          //           top: Radius.circular(8), bottom: Radius.zero)),
          //   margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
          //   child: RadioRow(
          //       items: controller.radiofilters,
          //       groupValue: controller.selectedradiofilter),
          // ),
          Obx(() => Padding(
                padding: const EdgeInsets.all(4.0),
                child: CupertinoSlidingSegmentedControl(
                    groupValue: controller.selectedradiofilter.value,
                    padding: EdgeInsets.zero,
                    children: Map.fromEntries(controller.radiofilters
                        .map((e) => MapEntry(e, Text(e)))),
                    onValueChanged: (value) {
                      controller.selectedradiofilter.value = value ?? "";
                      controller.pageController
                          .jumpToPage(controller.radiofilters.indexOf(value!));
                    }),
              )),
          // Middle Section taking up entire remaining space
          Expanded(
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: Container(
                  padding: EdgeInsets.all(4),
                  child: GetBuilder<ImportDigitextRunOrderController>(
                      init: controller,
                      id: "data",
                      builder: (digtexController) {
                        print("updating  grid");
                        if (digtexController.digitexRunOrderData != null) {
                          return PageView.builder(
                              controller: controller.pageController,
                              itemCount: controller.radiofilters.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    DataGridShowOnlyKeys(
                                      keysWidths: (controller
                                          .userDataSettings?.userSetting
                                          ?.firstWhere(
                                              (element) =>
                                                  element.controlName == "data",
                                              orElse: () => UserSetting())
                                          .userSettings),
                                      mapData: getPageData(index),
                                      formatDate: false,
                                      onload: (load) {
                                        if (index == 0) {
                                          controller.clientGridStateManager =
                                              load.stateManager;
                                        }
                                      },
                                      hideCode: false,
                                      onRowDoubleTap: (tapEvent) {
                                        DropDownValue? _client;
                                        if (index == 0) {
                                          Get.defaultDialog(
                                              radius: 2,
                                              title: "Map Clients",
                                              content: Column(
                                                children: [
                                                  InputFields.formField1(
                                                      hintTxt: "Digitex",
                                                      width: 0.24,
                                                      isEnable: false,
                                                      controller:
                                                          TextEditingController(
                                                              text: tapEvent
                                                                      .row
                                                                      .cells[
                                                                          "clientstoCreate"]
                                                                      ?.value ??
                                                                  "")),
                                                  DropDownField
                                                      .formDropDownSearchAPI2(
                                                          GlobalKey(), context,
                                                          parseKeyForKey:
                                                              "clientCode",
                                                          parseKeyForValue:
                                                              "clientName",
                                                          title: "Client",
                                                          url: ApiFactory
                                                              .IMPORT_DIGITEX_RUN_ORDER_CLIENT,
                                                          onchanged: (data) {
                                                    _client = data;
                                                  }),
                                                ],
                                              ),
                                              cancel: FormButtonWrapper(
                                                  btnText: "Map",
                                                  callback: () {
                                                    if (_client != null) {
                                                      controller
                                                          .updateClientData(
                                                              tapEvent,
                                                              _client!);
                                                    }
                                                  }),
                                              confirm: FormButtonWrapper(
                                                  btnText: "Clear",
                                                  callback: () {
                                                    controller.clearClientData(
                                                        tapEvent, _client!);
                                                  }));
                                        } else if (index == 3) {
                                          Get.defaultDialog(
                                              radius: 2,
                                              title: "Map Agency",
                                              content: Column(
                                                children: [
                                                  InputFields.formField1(
                                                      hintTxt: "Digitex",
                                                      width: 0.24,
                                                      isEnable: false,
                                                      controller:
                                                          TextEditingController(
                                                              text: tapEvent
                                                                      .row
                                                                      .cells[
                                                                          "agenciestoCreate"]
                                                                      ?.value ??
                                                                  "")),
                                                  DropDownField
                                                      .formDropDownSearchAPI2(
                                                          GlobalKey(), context,
                                                          parseKeyForKey:
                                                              "agencyCode",
                                                          parseKeyForValue:
                                                              "agencyName",
                                                          title: "Agency",
                                                          url: ApiFactory
                                                              .IMPORT_DIGITEX_RUN_ORDER_AGENCY,
                                                          onchanged: (data) {
                                                    _client = data;
                                                  }),
                                                ],
                                              ),
                                              cancel: FormButtonWrapper(
                                                  btnText: "Map",
                                                  callback: () {
                                                    if (_client != null) {
                                                      controller
                                                          .updateAgencyData(
                                                              tapEvent,
                                                              _client!);
                                                    }
                                                  }),
                                              confirm: FormButtonWrapper(
                                                  btnText: "Clear",
                                                  callback: () {
                                                    controller.clearAgencyData(
                                                        tapEvent, _client!);
                                                  }));
                                        }
                                      },
                                    ),
                                    if (index == 0)
                                      FormButtonWrapper(
                                        btnText: "Map Client",
                                        iconDataM:
                                            Icons.business_center_rounded,
                                        callback: () {
                                          controller.mapClients();
                                        },
                                      ),
                                    if (index == 3)
                                      FormButtonWrapper(
                                        btnText: "Map Agencies",
                                        iconDataM: Icons.people_alt_rounded,
                                        callback: () {
                                          controller.mapAgencies();
                                        },
                                      ),
                                  ],
                                );
                              });
                        } else {
                          return Container(
                            color: Colors.white,
                          );
                        }
                      })),
            ),
          ),
          GetBuilder<HomeController>(
              id: "buttons",
              init: Get.find<HomeController>(),
              builder: (btncontroller) {
                /* PermissionModel formPermissions = Get.find<MainController>()
                      .permissionList!
                      .lastWhere((element) {
                    return element.appFormName == "frmSegmentsDetails";
                  });*/
                PermissionModel formPermissions = Get.find<MainController>()
                    .permissionList!
                    .lastWhere((element) {
                  return element.appFormName == "frmBARBRunOrder";
                });

                return Card(
                  margin: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Container(
                    width: Get.width,
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 10,
                      // buttonHeight: 20,
                      alignment: WrapAlignment.start,
                      // mainAxisSize: MainAxisSize.max,
                      // pa
                      children: [
                        for (var btn in btncontroller.buttons!)
                          btn["name"] == "Save"
                              ? Obx(
                                  () => FormButtonWrapper(
                                    isEnabled: controller.allowSave.value,
                                    btnText: btn["name"],
                                    // isEnabled: btn['isDisabled'],
                                    callback: Utils.btnAccessHandler2(
                                                btn['name'],
                                                btncontroller,
                                                formPermissions) ==
                                            null
                                        ? null
                                        : () => btnHandler(btn['name']),
                                  ),
                                )
                              : FormButtonWrapper(
                                  btnText: btn["name"],
                                  // isEnabled: btn['isDisabled'],
                                  callback: Utils.btnAccessHandler2(btn['name'],
                                              btncontroller, formPermissions) ==
                                          null
                                      ? null
                                      : () => btnHandler(btn['name']),
                                ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  btnHandler(name) {
    switch (name) {
      case "Save":
        controller.saveRunOrder();
        break;
      case "Exit":
        Get.find<HomeController>().postUserGridSetting2(listStateManager: [
          {"data": controller.clientGridStateManager},
        ]);
        break;
      case "Clear":
        Get.delete<ImportDigitextRunOrderController>();
        Get.find<HomeController>().clearPage1();
        break;
    }
  }
}
